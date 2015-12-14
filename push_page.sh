#!/bin/bash

hexo clean && hexo g 
cp -rf public/* ../blog_page/
cd ../blog_page/
git add .
git cm 'page'
git push origin gh-pages:gh-pages

cd -
