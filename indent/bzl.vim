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

" Vim indent file
" Language:	Bazel (http://bazel.io)

if exists('b:did_indent')
  finish
endif

" Load base python indent.
if !exists('*GetPythonIndent')
  runtime! indent/python.vim
endif

let b:did_indent = 1

" Only enable bzl google indent if python google indent is enabled.
if !get(g:, 'no_google_python_indent')
  setlocal indentexpr=GetBzlIndent(v:lnum)
endif

if exists('*GetBzlIndent')
  finish
endif

let s:save_cpo = &cpo
set cpo-=C

" Maximum number of lines to look backwards.
let s:maxoff = 50

""
" Determine the correct indent level given an {lnum} in the current buffer.
function GetBzlIndent(lnum) abort
  let l:use_recursive_indent = !get(g:, 'no_google_python_recursive_indent')
  if l:use_recursive_indent
    " Backup and override indent setting variables.
    if exists('g:pyindent_nested_paren')
      let l:pyindent_nested_paren = g:pyindent_nested_paren
    endif
    if exists('g:pyindent_open_paren')
      let l:pyindent_open_paren = g:pyindent_open_paren
    endif
    " Vim 7.3.693 and later defines a shiftwidth() function to get the effective
    " shiftwidth value. Fall back to &shiftwidth if the function doesn't exist.
    let l:sw_expr = exists('*shiftwidth') ? 'shiftwidth()' : (&shiftwidth != 0 ? '&shiftwidth' : '&tabstop')
    let g:pyindent_nested_paren = l:sw_expr
    let g:pyindent_open_paren = l:sw_expr
  endif

  let l:indent = -1

  call cursor(a:lnum, 1)
  let [l:par_line, l:par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
      \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :" .
      \ " synIDattr(synID(line('.'), col('.'), 1), 'name')" .
      \ " =~ '\\(Comment\\|String\\)$'")
  if l:par_line > 0
    " Indent inside parens.
    if searchpair('(\|{\|\[', '', ')\|}\|\]', 'W',
      \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :" .
      \ " synIDattr(synID(line('.'), col('.'), 1), 'name')" .
      \ " =~ '\\(Comment\\|String\\)$'") && line('.') == a:lnum
      " If cursor is at close parens, match indent with open parens.
      " E.g.
      "   foo(
      "   )
      let l:indent = indent(l:par_line)
    else
      " Align with the open paren unless it is at the end of the line.
      " E.g.
      "   open_paren_not_at_EOL(100,
      "                         (200,
      "                          300),
      "                         400)
      "   open_paren_at_EOL(
      "       100, 200, 300, 400)
      call cursor(l:par_line, 1)
      if l:par_col != col('$') - 1
        let l:indent = l:par_col
      endif
    endif
  endif

  " Delegate the rest to the original function.
  if l:indent == -1
    let l:indent = GetPythonIndent(a:lnum)
  endif

  if l:use_recursive_indent
    " Restore global variables.
    if exists('l:pyindent_nested_paren')
      let g:pyindent_nested_paren = l:pyindent_nested_paren
    else
      unlet g:pyindent_nested_paren
    endif
    if exists('l:pyindent_open_paren')
      let g:pyindent_open_paren = l:pyindent_open_paren
    else
      unlet g:pyindent_open_paren
    endif
  endif

  return l:indent
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
