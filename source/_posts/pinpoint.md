---
title: pinpoint分析
date: 2017-05-06 01:00:00
categories:
- code
tags:
- tracing

mathjax: true
description: 
---

![](https://github.com/naver/pinpoint/raw/master/doc/img/ss_server-map.png)

pinpoint，不用侵入到用户代码，在JVM插入agent实现调用链。与鹰眼，zipkin等白盒方式不同的是，pinpoint不要侵入代码，可以称之为灰盒（论文将调用链分为三种，白盒灰盒，黑盒）。



<!--more-->

![](https://github.com/naver/pinpoint/raw/master/doc/img/ss_call-stack.png)




# 架构
![](https://github.com/naver/pinpoint/raw/master/doc/img/pinpoint-architecture.png)
分为三个组件，agent（最重要，核心功能），collector（收集，大家的做法都差不多），UI

# agent说明

> Pinpoint Agent attaches itself to a host application (such as Tomcat) as a java agent to instrument various classes for tracing. When a class marked for tracing is loaded into the JVM, the Agent injects code around pre-defined methods to collect and send trace data to the Collector.
  In addition to trace data, the agent also collects various information about the host application such as JVM arguments, loaded libraries, CPU usage, Memory Usage and Garbage Collection.

在JVM层插入agent，在指定方法外包一层自定义代码，加上trace data和JVM usage等信息

![](https://cloud.githubusercontent.com/assets/8037461/13870778/0073df06-ed22-11e5-97a3-ebe116186947.jpg)
如图所示
- 从FrountEnd出来的原始message之外被agent加上了transaction ID, span ID等等trace data，关于这些ID的作用，可以查看dapper的定义
- BackEnd收到消息后，先由agent把trace data解析出来，然后再把原始message交给BackEnd的方法

## 原理

在[安装文档](https://github.com/naver/pinpoint/blob/master/doc/installation.md#installation-3)上可以看到
> To wire up the agent, pass $AGENT_PATH/pinpoint-bootstrap-$VERSION.jar to the -javaagent JVM argument when running the application:
  - -javaagent:$AGENT_PATH/pinpoint-bootstrap-$VERSION.jar
  Additionally, Pinpoint Agent requires 2 command-line arguments in order to identify itself in the distributed system:
  - -Dpinpoint.agentId - uniquely identifies the application instance in which the agent is running on
  - -Dpinpoint.applicationName - groups a number of identical application instances as a single service

说明用的是JVM agent的方式,你假笨的[JVM源码分析之javaagent原理完全解读](http://www.infoq.com/cn/articles/javaagent-illustrated)对此有过分析。
大概就是，采用类似hook的机制，修改指定类某些方法，使之执行我的附加代码。在pinpoint则是，进行trace相关的操作

## 插件示例

[Sample_13_RPC_Client.java](https://github.com/naver/pinpoint-plugin-sample/blob/master/plugin/src/main/java/com/navercorp/pinpoint/plugin/sample/_13_RPC_Client/Sample_13_RPC_Client.java#L38)

```java
    public byte[] doInTransform(Instrumentor instrumentor, ClassLoader classLoader, String className, Class<?> classBeingRedefined, ProtectionDomain protectionDomain, byte[] classfileBuffer) throws InstrumentException {
        InstrumentClass target = instrumentor.getInstrumentClass(classLoader, className, classfileBuffer);

        target.addGetter("com.navercorp.pinpoint.plugin.sample._13_RPC_Client.ServerAddressGetter", "serverAddress");
        target.addGetter("com.navercorp.pinpoint.plugin.sample._13_RPC_Client.ServerPortGetter", "serverPort");

        // 这里在com.navercorp.plugin.sample.target.TargetClass13_Request的sendRequest增加了Interceptor
        target.getDeclaredMethod("sendRequest", "com.navercorp.plugin.sample.target.TargetClass13_Request").addInterceptor("com.navercorp.pinpoint.plugin.sample._13_RPC_Client.SendRequestInterceptor");

        return target.toBytecode();
    }
```

Interceptor有两个方法before和after
```java
    @Override
    public void before(Object target, Object arg0) {
        Trace trace = traceContext.currentTraceObject();
        if (trace == null) {
            return;
        }

        TargetClass13_Request request = (TargetClass13_Request) arg0;

        if (trace.canSampled()) {
            SpanEventRecorder recorder = trace.traceBlockBegin();

            // RPC call trace have to be recorded with a service code in RPC client code range.
            recorder.recordServiceType(SamplePluginConstants.MY_RPC_CLIENT_SERVICE_TYPE);

            // You have to issue a TraceId the receiver of this request will use.
            TraceId nextId = trace.getTraceId().getNextTraceId();

            // Then record it as next span id.
            recorder.recordNextSpanId(nextId.getSpanId());

            // Finally, pass some tracing data to the server.
            // How to put them in a message is protocol specific.
            // This example assumes that the target protocol message can include any metadata (like HTTP headers).
            request.addMetadata(SamplePluginConstants.META_TRANSACTION_ID, nextId.getTransactionId());
            request.addMetadata(SamplePluginConstants.META_SPAN_ID, Long.toString(nextId.getSpanId()));
            request.addMetadata(SamplePluginConstants.META_PARENT_SPAN_ID, Long.toString(nextId.getParentSpanId()));
            request.addMetadata(SamplePluginConstants.META_PARENT_APPLICATION_TYPE, Short.toString(traceContext.getServerTypeCode()));
            request.addMetadata(SamplePluginConstants.META_PARENT_APPLICATION_NAME, traceContext.getApplicationName());
            request.addMetadata(SamplePluginConstants.META_FLAGS, Short.toString(nextId.getFlags()));
        } else {
            // If sampling this transaction is disabled, pass only that infomation to the server.
            request.addMetadata(SamplePluginConstants.META_DO_NOT_TRACE, "1");
        }
    }
```

```java
    @Override
    public void after(Object target, Object arg0, Object result, Throwable throwable) {
        Trace trace = traceContext.currentTraceObject();
        if (trace == null) {
            return;
        }

        try {
            SpanEventRecorder recorder = trace.currentSpanEventRecorder();

            recorder.recordApi(descriptor);

            if (throwable == null) {
                // RPC client have to record end point (server address)
                String serverAddress = ((ServerAddressGetter) target)._$PREFIX$_getServerAddress();
                int port = ((ServerPortGetter) target)._$PREFIX$_getServerPort();
                recorder.recordEndPoint(serverAddress + ":" + port);

                TargetClass13_Request request = (TargetClass13_Request) arg0;
                // Optionally, record the destination id (logical name of server. e.g. DB name)
                recorder.recordDestinationId(request.getNamespace());
                recorder.recordAttribute(SamplePluginConstants.MY_RPC_PROCEDURE_ANNOTATION_KEY, request.getProcedure());
                recorder.recordAttribute(SamplePluginConstants.MY_RPC_ARGUMENT_ANNOTATION_KEY, request.getArgument());
                recorder.recordAttribute(SamplePluginConstants.MY_RPC_RESULT_ANNOTATION_KEY, result);
            } else {
                recorder.recordException(throwable);
            }
        } finally {
            trace.traceBlockEnd();
        }
    }
```
分别会在sendRequest的前后执行，完成生成trace data和record

----------------------------

`本博客欢迎转发,但请保留原作者信息`
github:[codejuan](https://github.com/CodeJuan)
博客地址:http://blog.decbug.com/


