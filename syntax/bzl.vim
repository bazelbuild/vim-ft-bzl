" Copyright 2014 Google Inc. All rights reserved.
"
" Licensed under the Apache License, Version 2.0 (the "License");
" you may not use this file except in compliance with the License.
" You may obtain a copy of the License at
"
"     http://www.apache.org/licenses/LICENSE-2.0
"
" Unless required by applicable law or agreed to in writing, software
" distributed under the License is distributed on an "AS IS" BASIS,
" WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
" See the License for the specific language governing permissions and
" limitations under the License.

" Vim syntax file
" Language:	Bazel (http://bazel.io)

if exists('b:current_syntax')
  finish
endif


runtime! syntax/python.vim

let b:current_syntax = 'bzl'

syn region bzlRule start='^\w\+($' end='^)\n*' transparent fold
syn region bzlList start='\[' end='\]' transparent fold
