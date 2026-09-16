"literally just syntax/c.vim with some modifications (and renaming C stuff to Oskar)
"  (not much else was changed) (ie: only changed/added what I needed for Oskar)

" Vim syntax file
" Language:		Oskar
" Maintainer:		The Vim Project <https://github.com/vim/vim>
" Last Change:		2026 Jun 01
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>

" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

let s:ft = matchstr(&ft, '^\%([^.]\)\+')

" check if this was included from cpp.vim
let s:in_cpp_family = exists("b:filetype_in_cpp_family")

" Optional embedded Autodoc parsing
" To enable it add: let g:oskar_autodoc = 1
" to your .vimrc
if exists("oskar_autodoc")
  syn include @cAutodoc <sfile>:p:h/autodoc.vim
  unlet b:current_syntax
endif

" A bunch of useful C keywords
syn keyword	oskarStatement	goto break return continue asm defer
syn keyword	oskarLabel		case default
syn keyword	oskarConditional	if else switch
syn keyword	oskarRepeat		while for do

syn keyword	oskarTodo		contained TODO FIXME XXX

" It's easy to accidentally add a space after a backslash that was intended
" for line continuation.  Some compilers allow it, which makes it
" unpredictable and should be avoided.
syn match	oskarBadContinuation contained "\\\s\+$"

" oskarCommentGroup allows adding matches for special things in comments
syn cluster	oskarCommentGroup	contains=oskarTodo,oskarBadContinuation

" String and Character constants
" Highlight special characters (those which have a backslash) differently
syn match	oskarSpecial	display contained "\\\%(x\x\+\|\o\{1,3}\|.\|$\)"
if !exists("oskar_no_utf")
  syn match	oskarSpecial	display contained "\\\%(u\x\{4}\|U\x\{8}\)"
endif

if !exists("oskar_no_cformat")
  " Highlight % items in strings.
  if !exists("oskar_no_c99") " ISO C99
    syn match	oskarFormat		display "%\%(\d\+\$\)\=[-+' #0*]*\%(\d*\|\*\|\*\d\+\$\)\%(\.\%(\d*\|\*\|\*\d\+\$\)\)\=\%([hlLjzt]\|ll\|hh\)\=\%([aAbdiuoxXDOUfFeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  else
    syn match	oskarFormat		display "%\%(\d\+\$\)\=[-+' #0*]*\%(\d*\|\*\|\*\d\+\$\)\%(\.\%(\d*\|\*\|\*\d\+\$\)\)\=\%([hlL]\|ll\)\=\%([bdiuoxXDOUfeEgGcCsSpn]\|\[\^\=.[^]]*\]\)" contained
  endif
  syn match	oskarFormat		display "%%" contained
endif

" oskarCppString: same as oskarString, but ends at end of line
if s:in_cpp_family && !exists("cpp_no_cpp11") && !exists("oskar_no_cformat")
  " ISO C++11
  syn region	oskarString		start=+\%(L\|u\|u8\|U\|R\|LR\|u8R\|uR\|UR\)\="+ skip=+\\\\\|\\"+ end=+"+ contains=oskarSpecial,oskarFormat,@Spell extend
  syn region 	oskarCppString	start=+\%(L\|u\|u8\|U\|R\|LR\|u8R\|uR\|UR\)\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=oskarSpecial,oskarFormat,@Spell
elseif s:ft ==# "oskar" && !exists("oskar_no_c11") && !exists("oskar_no_cformat")
  " ISO C99
  syn region	oskarString		start=+\%(L\|U\|u8\)\="+ skip=+\\\\\|\\"+ end=+"+ contains=oskarSpecial,oskarFormat,@Spell extend
  syn region	oskarCppString	start=+\%(L\|U\|u8\)\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=oskarSpecial,oskarFormat,@Spell
else
  " older C or C++
  syn match	oskarFormat		display "%%" contained
  syn region	oskarString		start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=oskarSpecial,oskarFormat,@Spell extend
  syn region	oskarCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=oskarSpecial,oskarFormat,@Spell
endif

syn region	oskarCppSkip	contained start="^\s*\%(%:\|#\)\s*\%(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\%(%:\|#\)\s*endif\>" contains=oskarSpaceError,oskarCppSkip

syn cluster	oskarStringGroup	contains=oskarCppString,oskarCppSkip

syn match	oskarCharacter	"L\='[^\\]'"
syn match	oskarCharacter	"L'[^']*'" contains=oskarSpecial
if exists("oskar_gnu")
  syn match	oskarSpecialError	"L\='\\[^'\"?\\abefnrtv]'"
  syn match	oskarSpecialCharacter "L\='\\['\"?\\abefnrtv]'"
else
  syn match	oskarSpecialError	"L\='\\[^'\"?\\abfnrtv]'"
  syn match	oskarSpecialCharacter "L\='\\['\"?\\abfnrtv]'"
endif
syn match	oskarSpecialCharacter display "L\='\\\o\{1,3}'"
syn match	oskarSpecialCharacter display "'\\x\x\{1,2}'"
syn match	oskarSpecialCharacter display "L'\\x\x\+'"

if (s:ft ==# "oskar" && !exists("oskar_no_c11")) || (s:in_cpp_family && !exists("cpp_no_cpp11"))
  " ISO C11 or ISO C++ 11
  if exists("oskar_no_cformat")
    syn region	oskarString		start=+\%(U\|u8\=\)"+ skip=+\\\\\|\\"+ end=+"+ contains=oskarSpecial,@Spell extend
  else
    syn region	oskarString		start=+\%(U\|u8\=\)"+ skip=+\\\\\|\\"+ end=+"+ contains=oskarSpecial,oskarFormat,@Spell extend
  endif
  syn match	oskarCharacter	"[Uu]'[^\\]'"
  syn match	oskarCharacter	"[Uu]'[^']*'" contains=oskarSpecial
  if exists("oskar_gnu")
    syn match	oskarSpecialError	"[Uu]'\\[^'\"?\\abefnrtv]'"
    syn match	oskarSpecialCharacter "[Uu]'\\['\"?\\abefnrtv]'"
  else
    syn match	oskarSpecialError	"[Uu]'\\[^'\"?\\abfnrtv]'"
    syn match	oskarSpecialCharacter "[Uu]'\\['\"?\\abfnrtv]'"
  endif
  syn match	oskarSpecialCharacter display "[Uu]'\\\o\{1,3}'"
  syn match	oskarSpecialCharacter display "[Uu]'\\x\x\+'"
endif

if (s:ft ==# "oskar" && !exists("oskar_no_c23")) || (s:in_cpp_family && !exists("cpp_no_cpp17"))
  syn match	oskarCharacter	"u8'[^\\]'"
  syn match	oskarCharacter	"u8'[^']*'" contains=oskarSpecial
  if exists("oskar_gnu")
    syn match	oskarSpecialError	"u8'\\[^'\"?\\abefnrtv]'"
    syn match	oskarSpecialCharacter "u8'\\['\"?\\abefnrtv]'"
  else
    syn match	oskarSpecialError	"u8'\\[^'\"?\\abfnrtv]'"
    syn match	oskarSpecialCharacter "u8'\\['\"?\\abfnrtv]'"
  endif
  syn match	oskarSpecialCharacter display "u8'\\\o\{1,3}'"
  syn match	oskarSpecialCharacter display "u8'\\x\x\+'"
endif

"when wanted, highlight trailing white space
if exists("oskar_space_errors")
  if !exists("oskar_no_trail_space_error")
    syn match	oskarSpaceError	display excludenl "\s\+$"
  endif
  if !exists("oskar_no_tab_space_error")
    syn match	oskarSpaceError	display " \+\t"me=e-1
  endif
endif

" This should be before oskarErrInParen to avoid problems with #define ({ xxx })
if exists("oskar_curly_error")
  syn match oskarCurlyError "}"
  syn region	oskarBlock		start="{" end="}" contains=ALLBUT,oskarBadBlock,oskarCurlyError,@oskarParenGroup,oskarErrInParen,oskarCppParen,oskarErrInBracket,oskarCppBracket,@oskarStringGroup,@Spell fold
else
  syn region	oskarBlock		start="{" end="}" transparent fold
endif

" Catch errors caused by wrong parenthesis and brackets.
" Also accept <% for {, %> for }, <: for [ and :> for ] (C99)
" But avoid matching <::.
syn cluster	oskarParenGroup	contains=oskarParenError,oskarIncluded,oskarSpecial,oskarCommentSkip,oskarCommentString,oskarComment2String,@oskarCommentGroup,oskarCommentStartError,oskarUserLabel,oskarBitField,oskarOctalZero,@oskarCppOutInGroup,oskarFormat,oskarNumber,oskarFloat,oskarOctal,oskarOctalError,oskarNumbersCom
if exists("oskar_no_curly_error")
  if s:in_cpp_family && !exists("cpp_no_cpp11")
    syn region	oskarParen		transparent start='(' end=')' contains=ALLBUT,@oskarParenGroup,oskarCppParen,@oskarStringGroup,@Spell
    " cCppParen: same as oskarParen but ends at end-of-line; used in oskarDefine
    syn region	oskarCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@oskarParenGroup,oskarParen,oskarString,@Spell
    syn match	oskarParenError	display ")"
    syn match	oskarErrInParen	display contained "^^<%\|^%>"
  else
    syn region	oskarParen		transparent start='(' end=')' contains=ALLBUT,oskarBlock,@oskarParenGroup,oskarCppParen,@oskarStringGroup,@Spell
    " cCppParen: same as oskarParen but ends at end-of-line; used in oskarDefine
    syn region	oskarCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@oskarParenGroup,oskarParen,oskarString,@Spell
    syn match	oskarParenError	display ")"
    syn match	oskarErrInParen	display contained "^[{}]\|^<%\|^%>"
  endif
elseif exists("oskar_no_bracket_error")
  if s:in_cpp_family && !exists("cpp_no_cpp11")
    syn region	oskarParen		transparent start='(' end=')' contains=ALLBUT,@oskarParenGroup,oskarCppParen,@oskarStringGroup,@Spell
    " cCppParen: same as oskarParen but ends at end-of-line; used in oskarDefine
    syn region	oskarCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@oskarParenGroup,oskarParen,oskarString,@Spell
    syn match	oskarParenError	display ")"
    syn match	oskarErrInParen	display contained "<%\|%>"
  else
    syn region	oskarParen		transparent start='(' end=')' end='}'me=s-1 contains=ALLBUT,oskarBlock,@oskarParenGroup,oskarCppParen,@oskarStringGroup,@Spell
    " cCppParen: same as oskarParen but ends at end-of-line; used in oskarDefine
    syn region	oskarCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@oskarParenGroup,oskarParen,oskarString,@Spell
    syn match	oskarParenError	display ")"
    syn match	oskarErrInParen	display contained "[{}]\|<%\|%>"
  endif
else
  if s:in_cpp_family && !exists("cpp_no_cpp11")
    syn region	oskarParen		transparent start='(' end=')' contains=ALLBUT,@oskarParenGroup,oskarCppParen,oskarErrInBracket,oskarCppBracket,@oskarStringGroup,@Spell
    " cCppParen: same as oskarParen but ends at end-of-line; used in oskarDefine
    syn region	oskarCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@oskarParenGroup,oskarErrInBracket,oskarParen,oskarBracket,oskarString,@Spell
    syn match	oskarParenError	display "[\])]"
    syn match	oskarErrInParen	display contained "<%\|%>"
    syn region	oskarBracket	transparent start='\[\|<::\@!' end=']\|:>' contains=ALLBUT,@oskarParenGroup,oskarErrInParen,oskarCppParen,oskarCppBracket,@oskarStringGroup,@Spell
  else
    syn region	oskarParen		transparent start='(' end=')' end='}'me=s-1 contains=ALLBUT,oskarBlock,@oskarParenGroup,oskarCppParen,oskarErrInBracket,oskarCppBracket,@oskarStringGroup,@Spell
    " cCppParen: same as oskarParen but ends at end-of-line; used in oskarDefine
    syn region	oskarCppParen	transparent start='(' skip='\\$' excludenl end=')' end='$' contained contains=ALLBUT,@oskarParenGroup,oskarErrInBracket,oskarParen,oskarBracket,oskarString,@Spell
    syn match	oskarParenError	display "[\])]"
    syn match	oskarErrInParen	display contained "[\]{}]\|<%\|%>"
    syn region	oskarBracket	transparent start='\[\|<::\@!' end=']\|:>' end='}'me=s-1 contains=ALLBUT,oskarBlock,@oskarParenGroup,oskarErrInParen,oskarCppParen,oskarCppBracket,@oskarStringGroup,@Spell
  endif
  " cCppBracket: same as oskarParen but ends at end-of-line; used in oskarDefine
  syn region	oskarCppBracket	transparent start='\[\|<::\@!' skip='\\$' excludenl end=']\|:>' end='$' contained contains=ALLBUT,@oskarParenGroup,oskarErrInParen,oskarParen,oskarBracket,oskarString,@Spell
  syn match	oskarErrInBracket	display contained "[);{}]\|<%\|%>"
endif

if s:ft ==# "oskar" || exists("cpp_no_cpp11")
  syn region	oskarBadBlock	keepend start="{" end="}" contained containedin=oskarParen,oskarBracket,oskarBadBlock transparent fold
endif

"integer number, or floating point number without a dot and with "f".
syn case ignore
syn match	oskarNumbers	display transparent "\<\d\|\.\d" contains=oskarNumber,oskarFloat,oskarOctalError,oskarOctal
" Same, but without octal error (for comments)
syn match	oskarNumbersCom	display contained transparent "\<\d\|\.\d" contains=oskarNumber,oskarFloat,oskarOctal

" cpp.vim handles these
if !exists("oskar_no_c23") && !s:in_cpp_family
  syn match	oskarNumber		display contained "\d\%('\=\d\+\)*\%(u\=l\{0,2}\|ll\=u\|u\=wb\|wbu\=\)\>"
  "hex number
  syn match	oskarNumber		display contained "0x\x\%('\=\x\+\)*\%(u\=l\{0,2}\|ll\=u\|u\=wb\|wbu\=\)\>"
  " Flag the first zero of an octal number as something special
  syn match	oskarOctal		display contained "0\o\%('\=\o\+\)*\%(u\=l\{0,2}\|ll\=u\|u\=wb\|wbu\=\)\>" contains=oskarOctalZero
  "binary number
  syn match	oskarNumber		display contained "0b[01]\%('\=[01]\+\)*\%(u\=l\{0,2}\|ll\=u\|u\=wb\|wbu\=\)\>"
else
  syn match	oskarNumber		display contained "\d\+\%(u\=l\{0,2}\|ll\=u\)\>"
  "hex number
  syn match	oskarNumber		display contained "0x\x\+\%(u\=l\{0,2}\|ll\=u\)\>"
  " Flag the first zero of an octal number as something special
  syn match	oskarOctal		display contained "0\o\+\%(u\=l\{0,2}\|ll\=u\)\>" contains=oskarOctalZero
  syn match	oskarOctalZero	display contained "\<0"
endif

"floating point number, with dot, optional exponent
syn match	oskarFloat		display contained "\d\+\.\d*\%(e[-+]\=\d\+\)\=[fl]\="
"floating point number, starting with a dot, optional exponent
syn match	oskarFloat		display contained "\.\d\+\%(e[-+]\=\d\+\)\=[fl]\=\>"
"floating point number, without dot, with exponent
syn match	oskarFloat		display contained "\d\+e[-+]\=\d\+[fl]\=\>"
if !exists("oskar_no_c99")
  "hexadecimal floating point number, optional leading digits, with dot, with exponent
  syn match	oskarFloat		display contained "0x\x*\.\x\+p[-+]\=\d\+[fl]\=\>"
  "hexadecimal floating point number, with leading digits, optional dot, with exponent
  syn match	oskarFloat		display contained "0x\x\+\.\=p[-+]\=\d\+[fl]\=\>"
endif

" flag an octal number with wrong digits
syn match	oskarOctalError	display contained "0\o*[89]\d*"
syn case match

if exists("oskar_comment_strings")
  " A comment can contain oskarString, oskarCharacter and oskarNumber.
  " But a "*/" inside a oskarString in a oskarComment DOES end the comment!  So we
  " need to use a special type of oskarString: oskarCommentString, which also ends on
  " "*/", and sees a "*" at the start of the line as comment again.
  " Unfortunately this doesn't very well work for // type of comments :-(
  syn match	oskarCommentSkip	contained "^\s*\*\%($\|\s\+\)"
  syn region oskarCommentString	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end=+\*/+me=s-1 contains=oskarSpecial,oskarCommentSkip
  syn region oskarComment2String	contained start=+L\=\\\@<!"+ skip=+\\\\\|\\"+ end=+"+ end="$" contains=oskarSpecial
  syn region  oskarCommentL	start="//" skip="\\$" end="$" keepend contains=@oskarCommentGroup,oskarComment2String,oskarCharacter,oskarNumbersCom,oskarSpaceError,oskarWrongComTail,@Spell
  if exists("oskar_no_comment_fold")
    " Use "extend" here to have preprocessor lines not terminate halfway a
    " comment.
    syn region oskarComment	matchgroup=oskarCommentStart start="/\*" end="\*/" contains=@oskarCommentGroup,oskarCommentStartError,oskarCommentString,oskarCharacter,oskarNumbersCom,oskarSpaceError,@Spell extend
  else
    syn region oskarComment	matchgroup=oskarCommentStart start="/\*" end="\*/" contains=@oskarCommentGroup,oskarCommentStartError,oskarCommentString,oskarCharacter,oskarNumbersCom,oskarSpaceError,@Spell fold extend
  endif
else
  syn region	oskarCommentL	start="//" skip="\\$" end="$" keepend contains=@oskarCommentGroup,oskarSpaceError,@Spell
  if exists("oskar_no_comment_fold")
    syn region	oskarComment	matchgroup=oskarCommentStart start="/\*" end="\*/" contains=@oskarCommentGroup,oskarCommentStartError,oskarSpaceError,@Spell extend
  else
    syn region	oskarComment	matchgroup=oskarCommentStart start="/\*" end="\*/" contains=@oskarCommentGroup,oskarCommentStartError,oskarSpaceError,@Spell fold extend
  endif
endif
" keep a // comment separately, it terminates a preproc. conditional
syn match	oskarCommentError	display "\*/"
syn match	oskarCommentStartError display "/\*"me=e-1 contained
syn match	oskarWrongComTail	display "\*/"

syn keyword	oskarOperator	sizeof
if exists("oskar_gnu")
  syn keyword	oskarType		__label__ __complex__
  syn keyword	oskarStatement	__asm__
  syn keyword	oskarOperator	__alignof__
  syn keyword	oskarOperator	typeof __typeof__
  syn keyword	oskarOperator	__real__ __imag__
  syn keyword	oskarStorageClass	__attribute__ __extension__
  syn keyword	oskarTypeQualifier	__const__ __restrict__ __volatile__
  syn keyword	oskarFunctionSpec	inline __inline __inline__ __noreturn__
endif
syn keyword	oskarType		int long short char void
syn keyword	oskarType		signed unsigned float double
if !exists("oskar_no_ansi") || exists("oskar_ansi_typedefs")
  syn keyword   oskarType		size_t ssize_t off_t wchar_t ptrdiff_t sig_atomic_t fpos_t
  syn keyword   oskarType		clock_t time_t va_list jmp_buf FILE DIR div_t ldiv_t
  syn keyword   oskarType		mbstate_t wctrans_t wint_t wctype_t
endif
if !exists("oskar_no_c99") " ISO C99
  syn keyword	oskarType		_Bool bool _Complex complex _Imaginary imaginary
  syn keyword	oskarType		int8_t int16_t int32_t int64_t
  syn keyword	oskarType		uint8_t uint16_t uint32_t uint64_t
  if !exists("oskar_no_bsd")
    " These are BSD specific.
    syn keyword	oskarType		u_int8_t u_int16_t u_int32_t u_int64_t
  endif
  syn keyword	oskarType		int_least8_t int_least16_t int_least32_t int_least64_t
  syn keyword	oskarType		uint_least8_t uint_least16_t uint_least32_t uint_least64_t
  syn keyword	oskarType		int_fast8_t int_fast16_t int_fast32_t int_fast64_t
  syn keyword	oskarType		uint_fast8_t uint_fast16_t uint_fast32_t uint_fast64_t
  syn keyword	oskarType		intptr_t uintptr_t
  syn keyword	oskarType		intmax_t uintmax_t
endif
if !exists("oskar_no_c23") && !s:in_cpp_family
  syn keyword	oskarOperator	typeof typeof_unqual
  syn keyword	oskarType           _BitInt _Decimal32 _Decimal64 _Decimal128
endif
if (s:ft ==# "oskar" && !exists("oskar_no_c23")) || (s:in_cpp_family && !exists("cpp_no_cpp11"))
  syn keyword	oskarType           nullptr_t
endif

syn keyword	oskarTypedef	typedef
syn keyword	oskarStructure	struct union enum
syn keyword	oskarStorageClass	static register auto extern
syn keyword	oskarTypeQualifier	const volatile
if !exists("oskar_no_c99") && !s:in_cpp_family
  syn keyword	oskarFunctionSpec	inline
  syn keyword	oskarTypeQualifier	restrict
endif
if (s:ft ==# "oskar" && !exists("oskar_no_c23")) || (s:in_cpp_family && !exists("cpp_no_cpp11"))
  syn keyword	oskarStorageClass	constexpr
endif
if !exists("oskar_no_c11")
  syn keyword	oskarStorageClass	_Alignas alignas
  syn keyword	oskarOperator	_Alignof alignof
  syn keyword	oskarTypeQualifier	_Atomic
  syn keyword	oskarOperator	_Generic
  syn keyword	oskarFunctionSpec	_Noreturn
  if !s:in_cpp_family
    syn keyword	oskarStandardAttribute	noreturn
  endif
  syn keyword	oskarOperator	_Static_assert static_assert
  syn keyword	oskarStorageClass	_Thread_local thread_local
  syn keyword   oskarType		char16_t char32_t
  syn keyword   oskarType		max_align_t
  " C11 atomics (take down the shield wall!)
  syn keyword	oskarType		atomic_bool atomic_char atomic_schar atomic_uchar
  syn keyword	Ctype		atomic_short atomic_ushort atomic_int atomic_uint
  syn keyword	oskarType		atomic_long atomic_ulong atomic_llong atomic_ullong
  syn keyword	oskarType		atomic_char16_t atomic_char32_t atomic_wchar_t
  syn keyword	oskarType		atomic_int_least8_t atomic_uint_least8_t
  syn keyword	oskarType		atomic_int_least16_t atomic_uint_least16_t
  syn keyword	oskarType		atomic_int_least32_t atomic_uint_least32_t
  syn keyword	oskarType		atomic_int_least64_t atomic_uint_least64_t
  syn keyword	oskarType		atomic_int_fast8_t atomic_uint_fast8_t
  syn keyword	oskarType		atomic_int_fast16_t atomic_uint_fast16_t
  syn keyword	oskarType		atomic_int_fast32_t atomic_uint_fast32_t
  syn keyword	oskarType		atomic_int_fast64_t atomic_uint_fast64_t
  syn keyword	oskarType		atomic_intptr_t atomic_uintptr_t
  syn keyword	oskarType		atomic_size_t atomic_ptrdiff_t
  syn keyword	oskarType		atomic_intmax_t atomic_uintmax_t
endif

if !exists("oskar_no_c23") && !s:in_cpp_family
  syn keyword	oskarStandardAttribute	deprecated fallthrough maybe_unused nodiscard
  syn keyword	oskarStandardAttribute	unsequenced reproducible
endif

if (s:ft ==# "oskar" && !exists("oskar_no_c23")) || (s:in_cpp_family && !exists("cpp_no_cpp20"))
  syn keyword   oskarType		char8_t
endif

if !exists("oskar_no_ansi") || exists("oskar_ansi_constants") || exists("oskar_gnu")
  if exists("oskar_gnu")
    syn keyword oskarConstant __GNUC__ __FUNCTION__ __PRETTY_FUNCTION__ __func__
  endif
  " TODO: __STDC_HOSTED__ is C99 and C++11
  syn keyword oskarConstant __LINE__ __FILE__ __DATE__ __TIME__ __STDC__ __STDC_VERSION__ __STDC_HOSTED__
  syn keyword oskarConstant CHAR_BIT MB_LEN_MAX MB_CUR_MAX
  syn keyword oskarConstant UCHAR_MAX UINT_MAX ULONG_MAX USHRT_MAX
  syn keyword oskarConstant CHAR_MIN INT_MIN LONG_MIN SHRT_MIN
  syn keyword oskarConstant CHAR_MAX INT_MAX LONG_MAX SHRT_MAX
  syn keyword oskarConstant SCHAR_MIN SINT_MIN SLONG_MIN SSHRT_MIN
  syn keyword oskarConstant SCHAR_MAX SINT_MAX SLONG_MAX SSHRT_MAX
  if !exists("oskar_no_c99")
    syn keyword oskarConstant __STDC_ISO_10646__ __STDC_IEC_559_COMPLEX__
    syn keyword oskarConstant __STDC_MB_MIGHT_NEQ_WC__
    syn keyword oskarConstant __func__ __VA_ARGS__
    syn keyword oskarConstant LLONG_MIN LLONG_MAX ULLONG_MAX
    syn keyword oskarConstant INT8_MIN INT16_MIN INT32_MIN INT64_MIN
    syn keyword oskarConstant INT8_MAX INT16_MAX INT32_MAX INT64_MAX
    syn keyword oskarConstant UINT8_MAX UINT16_MAX UINT32_MAX UINT64_MAX
    syn keyword oskarConstant INT_LEAST8_MIN INT_LEAST16_MIN INT_LEAST32_MIN INT_LEAST64_MIN
    syn keyword oskarConstant INT_LEAST8_MAX INT_LEAST16_MAX INT_LEAST32_MAX INT_LEAST64_MAX
    syn keyword oskarConstant UINT_LEAST8_MAX UINT_LEAST16_MAX UINT_LEAST32_MAX UINT_LEAST64_MAX
    syn keyword oskarConstant INT_FAST8_MIN INT_FAST16_MIN INT_FAST32_MIN INT_FAST64_MIN
    syn keyword oskarConstant INT_FAST8_MAX INT_FAST16_MAX INT_FAST32_MAX INT_FAST64_MAX
    syn keyword oskarConstant UINT_FAST8_MAX UINT_FAST16_MAX UINT_FAST32_MAX UINT_FAST64_MAX
    syn keyword oskarConstant INTPTR_MIN INTPTR_MAX UINTPTR_MAX
    syn keyword oskarConstant INTMAX_MIN INTMAX_MAX UINTMAX_MAX
    syn keyword oskarConstant PTRDIFF_MIN PTRDIFF_MAX SIG_ATOMIC_MIN SIG_ATOMIC_MAX
    syn keyword oskarConstant SIZE_MAX WCHAR_MIN WCHAR_MAX WINT_MIN WINT_MAX
  endif
  if !exists("oskar_no_c11")
    syn keyword oskarConstant __STDC_UTF_16__ __STDC_UTF_32__ __STDC_ANALYZABLE__
    syn keyword oskarConstant __STDC_LIB_EXT1__ __STDC_NO_ATOMICS__
    syn keyword oskarConstant __STDC_NO_COMPLEX__ __STDC_NO_THREADS__
    syn keyword oskarConstant __STDC_NO_VLA__
  endif
  if !exists("oskar_no_c23")
    syn keyword oskarConstant __STDC_UTF_16__ __STDC_UTF_32__
    syn keyword oskarConstant __STDC_EMBED_NOT_FOUND__ __STDC_EMBED_FOUND__
    syn keyword oskarConstant __STDC_EMBED_EMPTY__ __STDC_IEC_60559_BFP__
    syn keyword oskarConstant __STDC_IEC_60559_DFP__ __STDC_IEC_60559_COMPLEX__
    syn keyword oskarConstant __STDC_IEC_60559_TYPES__
    syn keyword oskarConstant BITINT_MAXWIDTH
  endif
  if (s:ft ==# "oskar" && !exists("oskar_no_c23")) || (s:in_cpp_family && !exists("cpp_no_cpp20"))
    syn keyword oskarConstant __VA_OPT__
  endif
  if (s:ft ==# "oskar" && !exists("oskar_no_c23")) || (s:in_cpp_family && !exists("cpp_no_cpp11"))
    syn keyword oskarConstant nullptr
  endif
  syn keyword oskarConstant FLT_RADIX FLT_ROUNDS FLT_DIG FLT_MANT_DIG FLT_EPSILON DBL_DIG DBL_MANT_DIG DBL_EPSILON
  syn keyword oskarConstant LDBL_DIG LDBL_MANT_DIG LDBL_EPSILON FLT_MIN FLT_MAX FLT_MIN_EXP FLT_MAX_EXP FLT_MIN_10_EXP FLT_MAX_10_EXP
  syn keyword oskarConstant DBL_MIN DBL_MAX DBL_MIN_EXP DBL_MAX_EXP DBL_MIN_10_EXP DBL_MAX_10_EXP LDBL_MIN LDBL_MAX LDBL_MIN_EXP LDBL_MAX_EXP
  syn keyword oskarConstant LDBL_MIN_10_EXP LDBL_MAX_10_EXP HUGE_VAL CLOCKS_PER_SEC NULL LC_ALL LC_COLLATE LC_CTYPE LC_MONETARY
  syn keyword oskarConstant LC_NUMERIC LC_TIME SIG_DFL SIG_ERR SIG_IGN SIGABRT SIGFPE SIGILL SIGHUP SIGINT SIGSEGV SIGTERM
  " Add POSIX signals as well...
  syn keyword oskarConstant SIGABRT SIGALRM SIGCHLD SIGCONT SIGFPE SIGHUP SIGILL SIGINT SIGKILL SIGPIPE SIGQUIT SIGSEGV
  syn keyword oskarConstant SIGSTOP SIGTERM SIGTRAP SIGTSTP SIGTTIN SIGTTOU SIGUSR1 SIGUSR2
  syn keyword oskarConstant _IOFBF _IOLBF _IONBF BUFSIZ EOF WEOF FOPEN_MAX FILENAME_MAX L_tmpnam
  syn keyword oskarConstant SEEK_CUR SEEK_END SEEK_SET TMP_MAX EXIT_FAILURE EXIT_SUCCESS RAND_MAX
  syn keyword oskarConstant stdin stdout stderr
  " POSIX 2001, in unistd.h
  syn keyword oskarConstant STDIN_FILENO STDOUT_FILENO STDERR_FILENO
  " used in assert.h
  syn keyword oskarConstant NDEBUG
  " POSIX 2001
  syn keyword oskarConstant SIGBUS SIGPOLL SIGPROF SIGSYS SIGURG SIGVTALRM SIGXCPU SIGXFSZ
  " POSIX Issue 8 (post 2017)
  syn keyword oskarConstant SIGWINCH
  " non-POSIX signals
  syn keyword oskarConstant SIGINFO SIGIO
  " Add POSIX errors as well.  List comes from:
  " http://pubs.opengroup.org/onlinepubs/9699919799/basedefs/errno.h.html
  syn keyword oskarConstant E2BIG EACCES EADDRINUSE EADDRNOTAVAIL EAFNOSUPPORT EAGAIN EALREADY EBADF
  syn keyword oskarConstant EBADMSG EBUSY ECANCELED ECHILD ECONNABORTED ECONNREFUSED ECONNRESET EDEADLK
  syn keyword oskarConstant EDESTADDRREQ EDOM EDQUOT EEXIST EFAULT EFBIG EHOSTUNREACH EIDRM EILSEQ
  syn keyword oskarConstant EINPROGRESS EINTR EINVAL EIO EISCONN EISDIR ELOOP EMFILE EMLINK EMSGSIZE
  syn keyword oskarConstant EMULTIHOP ENAMETOOLONG ENETDOWN ENETRESET ENETUNREACH ENFILE ENOBUFS ENODATA
  syn keyword oskarConstant ENODEV ENOENT ENOEXEC ENOLCK ENOLINK ENOMEM ENOMSG ENOPROTOOPT ENOSPC ENOSR
  syn keyword oskarConstant ENOSTR ENOSYS ENOTBLK ENOTCONN ENOTDIR ENOTEMPTY ENOTRECOVERABLE ENOTSOCK ENOTSUP
  syn keyword oskarConstant ENOTTY ENXIO EOPNOTSUPP EOVERFLOW EOWNERDEAD EPERM EPIPE EPROTO
  syn keyword oskarConstant EPROTONOSUPPORT EPROTOTYPE ERANGE EROFS ESPIPE ESRCH ESTALE ETIME ETIMEDOUT
  syn keyword oskarConstant ETXTBSY EWOULDBLOCK EXDEV
  " math.h
  syn keyword oskarConstant M_E M_LOG2E M_LOG10E M_LN2 M_LN10 M_PI M_PI_2 M_PI_4
  syn keyword oskarConstant M_1_PI M_2_PI M_2_SQRTPI M_SQRT2 M_SQRT1_2
endif
if !exists("oskar_no_c99") " ISO C99
  syn keyword oskarConstant true false
  syn keyword oskarConstant INFINITY NAN
  " math.h
  syn keyword oskarConstant HUGE_VAL HUGE_VALF HUGE_VALL
  syn keyword oskarConstant FP_FAST_FMAF FP_FAST_FMA FP_FAST_FMAL
  syn keyword oskarConstant FP_ILOGB0 FP_ILOGBNAN
  syn keyword oskarConstant math_errhandling MATH_ERRNO MATH_ERREXCEPT
  syn keyword oskarConstant FP_NORMAL FP_SUBNORMAL FP_ZERO FP_INFINITE FP_NAN
endif

" Accept %: for # (C99)
syn cluster	oskarPreProcGroup	contains=oskarPreCondit,oskarIncluded,oskarInclude,oskarDefine,oskarErrInParen,oskarErrInBracket,oskarUserLabel,oskarSpecial,oskarOctalZero,oskarCppOutWrapper,oskarCppInWrapper,@oskarCppOutInGroup,oskarFormat,oskarNumber,oskarFloat,oskarOctal,oskarOctalError,oskarNumbersCom,oskarString,oskarCommentSkip,oskarCommentString,oskarComment2String,@oskarCommentGroup,oskarCommentStartError,oskarParen,oskarBracket,oskarMulti,oskarBadBlock
if !exists("oskar_no_c23")
  syn region	oskarPreCondit	start="^\s*\zs\%(%:\|#\)\s*\%(el\)\=\%(if\|ifdef\|ifndef\)\>" skip="\\$" end="$" keepend contains=oskarComment,oskarCommentL,oskarCppString,oskarCharacter,oskarCppParen,oskarParenError,oskarNumbers,oskarCommentError,oskarSpaceError
else
  syn region	oskarPreCondit	start="^\s*\zs\%(%:\|#\)\s*\%(if\|ifdef\|ifndef\|elif\)\>"    skip="\\$" end="$" keepend contains=oskarComment,oskarCommentL,oskarCppString,oskarCharacter,oskarCppParen,oskarParenError,oskarNumbers,oskarCommentError,oskarSpaceError
endif
syn match	oskarPreConditMatch	display "^\s*\zs\%(%:\|#\)\s*\%(else\|endif\)\>"
if !exists("oskar_no_if0")
  syn cluster	oskarCppOutInGroup	contains=oskarCppInIf,oskarCppInElse,oskarCppInElse2,oskarCppOutIf,oskarCppOutIf2,oskarCppOutElse,oskarCppInSkip,oskarCppOutSkip
  syn region	oskarCppOutWrapper	start="^\s*\zs\%(%:\|#\)\s*if\s\+0\+\s*\%($\|//\|/\*\|&\)" end=".\@=\|$" contains=oskarCppOutIf,oskarCppOutElse,@NoSpell fold
  syn region	oskarCppOutIf	contained start="0\+" matchgroup=oskarCppOutWrapper end="^\s*\%(%:\|#\)\s*endif\>" contains=oskarCppOutIf2,oskarCppOutElse
  if !exists("oskar_no_if0_fold")
    if !exists("oskar_no_c23")
      syn region	oskarCppOutIf2	contained matchgroup=oskarCppOutWrapper start="0\+" end="^\s*\%(%:\|#\)\s*\%(else\>\|el\%(if\|ifdef\|ifndef\)\s\+\%(0\+\s*\%($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=oskarSpaceError,oskarCppOutSkip,@Spell fold
    else
      syn region	oskarCppOutIf2	contained matchgroup=oskarCppOutWrapper start="0\+" end="^\s*\%(%:\|#\)\s*\%(else\>\|elif\s\+\%(0\+\s*\%($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=oskarSpaceError,oskarCppOutSkip,@Spell fold
    endif
  else
    if !exists("oskar_no_c23")
      syn region	oskarCppOutIf2	contained matchgroup=oskarCppOutWrapper start="0\+" end="^\s*\%(%:\|#\)\s*\%(else\>\|el\%(if\|ifdef\|ifndef\)\s\+\%(0\+\s*\%($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=oskarSpaceError,oskarCppOutSkip,@Spell
    else
      syn region	oskarCppOutIf2	contained matchgroup=oskarCppOutWrapper start="0\+" end="^\s*\%(%:\|#\)\s*\%(else\>\|elif\s\+\%(0\+\s*\%($\|//\|/\*\|&\)\)\@!\|endif\>\)"me=s-1 contains=oskarSpaceError,oskarCppOutSkip,@Spell
    endif
  endif
  if !exists("oskar_no_c23")
    syn region	oskarCppOutElse	contained matchgroup=oskarCppOutWrapper start="^\s*\%(%:\|#\)\s*\%(else\|el\%(if\|ifdef\|ifndef\)\)" end="^\s*\%(%:\|#\)\s*endif\>"me=s-1 contains=TOP,oskarPreCondit
  else
    syn region	oskarCppOutElse	contained matchgroup=oskarCppOutWrapper start="^\s*\%(%:\|#\)\s*\%(else\|elif\)" end="^\s*\%(%:\|#\)\s*endif\>"me=s-1 contains=TOP,oskarPreCondit
  endif
  syn region	oskarCppInWrapper	start="^\s*\zs\%(%:\|#\)\s*if\s\+0*[1-9]\d*\s*\%($\|//\|/\*\||\)" end=".\@=\|$" contains=oskarCppInIf,oskarCppInElse fold
  syn region	cCppInIf	contained matchgroup=oskarCppInWrapper start="\d\+" end="^\s*\%(%:\|#\)\s*endif\>" contains=TOP,oskarPreCondit
  if !exists("oskar_no_if0_fold")
    if !exists("oskar_no_c23")
      syn region	cCppInElse	contained start="^\s*\%(%:\|#\)\s*\%(else\>\|el\%(if\|ifdef\|ifndef\)\s\+\%(0*[1-9]\d*\s*\%($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=oskarCppInIf contains=oskarCppInElse2 fold
    else
      syn region	cCppInElse	contained start="^\s*\%(%:\|#\)\s*\%(else\>\|elif\s\+\%(0*[1-9]\d*\s*\%($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=oskarCppInIf contains=oskarCppInElse2 fold
    endif
  else
    if !exists("oskar_no_c23")
      syn region	cCppInElse	contained start="^\s*\%(%:\|#\)\s*\%(else\>\|el\%(if\|ifdef\|ifndef\)\s\+\%(0*[1-9]\d*\s*\%($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=oskarCppInIf contains=oskarCppInElse2
    else
      syn region	cCppInElse	contained start="^\s*\%(%:\|#\)\s*\%(else\>\|elif\s\+\%(0*[1-9]\d*\s*\%($\|//\|/\*\||\)\)\@!\)" end=".\@=\|$" containedin=oskarCppInIf contains=oskarCppInElse2
    endif
  endif
  if !exists("oskar_no_c23")
    syn region	oskarCppInElse2	contained matchgroup=oskarCppInWrapper start="^\s*\%(%:\|#\)\s*\%(else\|el\%(if\|ifdef\|ifndef\)\)\%([^/]\|/[^/*]\)*" end="^\s*\%(%:\|#\)\s*endif\>"me=s-1 contains=oskarSpaceError,oskarCppOutSkip,@Spell
  else
    syn region	oskarCppInElse2	contained matchgroup=oskarCppInWrapper start="^\s*\%(%:\|#\)\s*\%(else\|elif\)\%([^/]\|/[^/*]\)*" end="^\s*\%(%:\|#\)\s*endif\>"me=s-1 contains=oskarSpaceError,oskarCppOutSkip,@Spell
  endif
  syn region	oskarCppOutSkip	contained start="^\s*\%(%:\|#\)\s*\%(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\%(%:\|#\)\s*endif\>" contains=oskarSpaceError,oskarCppOutSkip
  syn region	cCppInSkip	contained matchgroup=oskarCppInWrapper start="^\s*\%(%:\|#\)\s*\%(if\s\+\%(\d\+\s*\%($\|//\|/\*\||\|&\)\)\@!\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\%(%:\|#\)\s*endif\>" containedin=oskarCppOutElse,oskarCppInIf,oskarCppInSkip contains=TOP,oskarPreProc
endif
syn region	oskarIncluded	display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	oskarIncluded	display contained "<[^>]*>"
syn match	oskarInclude	display "^\s*\zs\%(%:\|#\)\s*include\>\s*["<]" contains=oskarIncluded
if !exists("oskar_no_c23") && !s:in_cpp_family
  syn region	oskarInclude	start="^\s*\zs\%(%:\|#\)\s*embed\>" skip="\\$" end="$" keepend contains=oskarEmbed,oskarComment,oskarCommentL,oskarCppString,oskarCharacter,oskarCppParen,oskarParenError,oskarNumbers,oskarCommentError,oskarSpaceError
  syn match     cEmbed		contained "\%(%:\|#\)\s*embed\>" nextgroup=oskarIncluded skipwhite transparent
  syn cluster	oskarPreProcGroup	add=oskarEmbed
endif
"syn match cLineSkip	"\\$"
syn region	oskarDefine		start="^\s*\zs\%(%:\|#\)\s*\%(define\|undef\)\>" skip="\\$" end="$" keepend contains=ALLBUT,@oskarPreProcGroup,@Spell
syn region	oskarPreProc	start="^\s*\zs\%(%:\|#\)\s*\%(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend contains=ALLBUT,@oskarPreProcGroup,@Spell

" Optional embedded Autodoc parsing
if exists("oskar_autodoc")
  syn match cAutodocReal display contained "\%(//\|[/ \t\v]\*\|^\*\)\@2<=!.*" contains=@cAutodoc containedin=oskarComment,oskarCommentL
  syn cluster oskarCommentGroup add=oskarAutodocReal
  syn cluster oskarPreProcGroup add=oskarAutodocReal
endif

" be able to fold #pragma regions
syn region	oskarPragma		start="^\s*#pragma\s\+region\>" end="^\s*#pragma\s\+endregion\>" transparent keepend extend fold

" Highlight User Labels
syn cluster	oskarMultiGroup	contains=oskarIncluded,oskarSpecial,oskarCommentSkip,oskarCommentString,oskarComment2String,@oskarCommentGroup,oskarCommentStartError,oskarUserCont,oskarUserLabel,oskarBitField,oskarOctalZero,oskarCppOutWrapper,oskarCppInWrapper,@oskarCppOutInGroup,oskarFormat,oskarNumber,oskarFloat,oskarOctal,oskarOctalError,oskarNumbersCom,oskarCppParen,oskarCppBracket,oskarCppString
if s:ft ==# "oskar" || exists("cpp_no_cpp11")
  syn region	oskarMulti		transparent start='?' skip='::' end=':' contains=ALLBUT,@oskarMultiGroup,@Spell,@oskarStringGroup
endif
" Avoid matching foo::bar() in C++ by requiring that the next char is not ':'
syn cluster	oskarLabelGroup	contains=oskarUserLabel
syn match	oskarUserCont	display "^\s*\zs\I\i*\s*:$" contains=@oskarLabelGroup
syn match	oskarUserCont	display ";\s*\zs\I\i*\s*:$" contains=@oskarLabelGroup
if s:in_cpp_family
  syn match	oskarUserCont	display "^\s*\zs\%(class\|struct\|enum\)\@!\I\i*\s*:[^:]"me=e-1 contains=@oskarLabelGroup
  syn match	oskarUserCont	display ";\s*\zs\%(class\|struct\|enum\)\@!\I\i*\s*:[^:]"me=e-1 contains=@oskarLabelGroup
else
  syn match	oskarUserCont	display "^\s*\zs\I\i*\s*:[^:]"me=e-1 contains=@oskarLabelGroup
  syn match	oskarUserCont	display ";\s*\zs\I\i*\s*:[^:]"me=e-1 contains=@oskarLabelGroup
endif

syn match	oskarUserLabel	display "\I\i*" contained

" Avoid recognizing most bitfields as labels
syn match	oskarBitField	display "^\s*\zs\I\i*\s*:\s*[1-9]"me=e-1 contains=oskarType
syn match	oskarBitField	display ";\s*\zs\I\i*\s*:\s*[1-9]"me=e-1 contains=oskarType

if exists("oskar_functions")
  syn match oskarFunction "\<\h\w*\ze\_s*("
 endif

if exists("oskar_function_pointers")
  syn match oskarFunctionPointer "\%((\s*\*\s*\)\@<=\h\w*\ze\s*)\_s*(.*)"
endif

if exists("oskar_minlines")
  let b:oskar_minlines = c_minlines
else
  if !exists("oskar_no_if0")
    let b:oskar_minlines = 50	" #if 0 constructs can be long
  else
    let b:oskar_minlines = 15	" mostly for () constructs
  endif
endif
if exists("oskar_curly_error")
  syn sync fromstart
else
  exec "syn sync ccomment oskarComment minlines=" . b:oskar_minlines
endif

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link oskarFormat		oskarSpecial
hi def link oskarCppString		oskarString
hi def link oskarCommentL		oskarComment
hi def link oskarCommentStart	oskarComment
hi def link oskarLabel		Label
hi def link oskarUserLabel		Label
hi def link oskarConditional	Conditional
hi def link oskarRepeat		Repeat
hi def link oskarCharacter		Character
hi def link oskarSpecialCharacter	oskarSpecial
hi def link oskarNumber		Number
hi def link oskarOctal		Number
hi def link oskarOctalZero		PreProc	 " link this to Error if you want
hi def link oskarFloat		Float
hi def link oskarOctalError		oskarError
hi def link oskarParenError		oskarError
hi def link oskarErrInParen		oskarError
hi def link oskarErrInBracket	oskarError
hi def link oskarCommentError	oskarError
hi def link oskarCommentStartError	oskarError
hi def link oskarSpaceError		oskarError
hi def link oskarWrongComTail	oskarError
hi def link oskarSpecialError	oskarError
hi def link oskarCurlyError		oskarError
hi def link oskarOperator		Operator
hi def link oskarStructure		Structure
hi def link oskarTypedef		Structure
hi def link oskarStorageClass	StorageClass
hi def link oskarTypeQualifier	oskarStorageClass
hi def link oskarFunctionSpec	oskarStorageClass
hi def link oskarStandardAttribute	oskarStorageClass
hi def link oskarInclude		Include
hi def link oskarPreProc		PreProc
hi def link oskarDefine		Macro
hi def link oskarIncluded		oskarString
hi def link oskarError		Error
hi def link oskarStatement		Statement
hi def link oskarCppInWrapper	oskarCppOutWrapper
hi def link oskarCppOutWrapper	oskarPreCondit
hi def link oskarPreConditMatch	oskarPreCondit
hi def link oskarPreCondit		PreCondit
hi def link oskarType		Type
hi def link oskarConstant		Constant
hi def link oskarCommentString	oskarString
hi def link oskarComment2String	oskarString
hi def link oskarCommentSkip	oskarComment
hi def link oskarString		String
hi def link oskarComment		Comment
hi def link oskarSpecial		SpecialChar
hi def link oskarTodo		Todo
hi def link oskarBadContinuation	Error
hi def link oskarCppOutSkip		oskarCppOutIf2
hi def link oskarCppInElse2		oskarCppOutIf2
hi def link oskarCppOutIf2		oskarCppOut
hi def link oskarCppOut		Comment
hi def link oskarFunction		Function
hi def link oskarFunctionPointer	Function

let b:current_syntax = "oskar"

unlet s:ft

let &cpo = s:cpo_save
unlet s:cpo_save
" vim: ts=8
