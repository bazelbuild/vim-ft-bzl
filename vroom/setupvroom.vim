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
" under vroom.

" Install maktaba from local dir.
let s:repo = expand('<sfile>:p:h:h')
let s:search_dir = fnamemodify(s:repo, ':h')
" We'd like to use maktaba#path#Join, but maktaba doesn't exist yet.
let s:slash = exists('+shellslash') && !&shellslash ? '\' : '/'
for s:plugin_dirname in ['maktaba', 'vim-maktaba']
  let s:bootstrap_path_parts = [s:search_dir, s:plugin_dirname, 'bootstrap.vim']
  let s:bootstrap_path = join(s:bootstrap_path_parts, s:slash)
  if filereadable(s:bootstrap_path)
    execute 'source' s:bootstrap_path
    break
  endif
endfor

" Install the ft-bzl plugin.
call maktaba#plugin#GetOrInstall(s:repo)

" Support vroom's fake shell executable and don't try to override it to sh.
call maktaba#syscall#SetUsableShellRegex('\v<shell\.vroomfaker$')
