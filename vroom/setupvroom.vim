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

" This file bootstraps the ft-bzl plugin and configures it to work properly
" under vroom. It also defines test helpers like CheckEq.

let s:repo = expand('<sfile>:p:h:h')

" Install the ft-bzl plugin.
execute 'set runtimepath+=' . s:repo

function CheckEq(actual, expected) abort
  if type(a:actual) != type(a:expected) || a:actual !=# a:expected
    let l:fmt = 'ERROR(BadValue): Expected %s. Got %s.'
    echohl ErrorMsg
    echomsg printf(l:fmt, string(a:expected), string(a:actual))
    echohl NONE
  endif
  return a:actual
endfunction

function CheckContainsAll(actual, items) abort
  let l:missing = filter(copy(a:items), 'index(a:actual, v:val) == -1')
  if !empty(l:missing)
    let l:fmt = 'ERROR(BadValue): Expected %s to contain %s. Missing %s.'
    echohl ErrorMsg
    echomsg printf(l:fmt, string(a:actual), string(a:items), string(l:missing))
    echohl NONE
  endif
  return a:actual
endfunction
