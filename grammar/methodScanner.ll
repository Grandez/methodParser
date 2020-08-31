/* Scanner for calc++.   -*- C++ -*-

   Copyright (C) 2005--2015, 2018--2020 Free Software Foundation, Inc.

   This file is part of Bison, the GNU Compiler Compiler.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

%{ /* -*- C++ -*- */
# include <cerrno>
# include <climits>
# include <cstdlib>
# include <cstring> // strerror
# include <string>
# include <sstream>
# include "driver.hpp"
# include "methodParser.hpp"

%}

%{
#if defined __clang__
# define CLANG_VERSION (__clang_major__ * 100 + __clang_minor__)
#endif

// Clang and ICC like to pretend they are GCC.
#if defined __GNUC__ && !defined __clang__ && !defined __ICC
# define GCC_VERSION (__GNUC__ * 100 + __GNUC_MINOR__)
#endif

// Pacify warnings in yy_init_buffer (observed with Flex 2.6.4)
// and GCC 6.4.0, 7.3.0 with -O3.
#if defined GCC_VERSION && 600 <= GCC_VERSION
# pragma GCC diagnostic ignored "-Wnull-dereference"
#endif

// This example uses Flex's C back end, yet compiles it as C++.
// So expect warnings about C style casts and NULL.
#if defined CLANG_VERSION && 500 <= CLANG_VERSION
# pragma clang diagnostic ignored "-Wold-style-cast"
# pragma clang diagnostic ignored "-Wzero-as-null-pointer-constant"
#elif defined GCC_VERSION && 407 <= GCC_VERSION
# pragma GCC diagnostic ignored "-Wold-style-cast"
# pragma GCC diagnostic ignored "-Wzero-as-null-pointer-constant"
#endif

#define FLEX_VERSION (YY_FLEX_MAJOR_VERSION * 100 + YY_FLEX_MINOR_VERSION)

// Old versions of Flex (2.5.35) generate an incomplete documentation comment.
//
//  In file included from src/scan-code-c.c:3:
//  src/scan-code.c:2198:21: error: empty paragraph passed to '@param' command
//        [-Werror,-Wdocumentation]
//   * @param line_number
//     ~~~~~~~~~~~~~~~~~^
//  1 error generated.
#if FLEX_VERSION < 206 && defined CLANG_VERSION
# pragma clang diagnostic ignored "-Wdocumentation"
#endif

// Old versions of Flex (2.5.35) use 'register'.  Warnings introduced in
// GCC 7 and Clang 6.
#if FLEX_VERSION < 206
# if defined CLANG_VERSION && 600 <= CLANG_VERSION
#  pragma clang diagnostic ignored "-Wdeprecated-register"
# elif defined GCC_VERSION && 700 <= GCC_VERSION
#  pragma GCC diagnostic ignored "-Wregister"
# endif
#endif

#if FLEX_VERSION < 206
# if defined CLANG_VERSION
#  pragma clang diagnostic ignored "-Wconversion"
#  pragma clang diagnostic ignored "-Wdocumentation"
#  pragma clang diagnostic ignored "-Wshorten-64-to-32"
#  pragma clang diagnostic ignored "-Wsign-conversion"
# elif defined GCC_VERSION
#  pragma GCC diagnostic ignored "-Wconversion"
#  pragma GCC diagnostic ignored "-Wsign-conversion"
# endif
#endif
%}

%option nodefault noyywrap nounput noinput batch debug

%{
  // A number symbol corresponding to the value in S.
  yy::parser::symbol_type
  make_NUMBER (const std::string &s, const yy::parser::location_type& loc);
%}

blank  [ \t\r]
ID     [a-zA-Z_0-9]+

%{
  // Code run each time a pattern is matched.
  # define YY_USER_ACTION  loc.columns (yyleng);
%}

%x COMMENT QUOTE1 QUOTE2


%%
%{
  // A handy shortcut to the location held by the driver.
  yy::location& loc = drv.location;
  // Code run each time yylex is called.
  loc.step ();
  std::stringstream str;
%}

<<EOF>>    { return yy::parser::make_YYEOF (loc); }
{blank}+   loc.step ();
\n+        loc.lines (yyleng); loc.step ();

#(\\.)           { /* comentatior */ }
\"(\$\{.*\}|\\.|[^\"\\])*\"        { return yy::parser::make_STRING(yytext, yy::location()); }
\'(\$\{.*\}|\\.|[^\'\\])*\'         { return yy::parser::make_STRING(yytext, yy::location()); }

"("        { return yy::parser::make_LPAR  (yytext, yy::location());  }
")"        { return yy::parser::make_RPAR  (yytext, yy::location());  }
"="        { return yy::parser::make_ASSIGN(yytext, yy::location());  }
","        { return yy::parser::make_COMMA (yytext, yy::location());  }
`{ID}`     { return yy::parser::make_DATA  (yytext, yy::location());  }
{ID}       { return yy::parser::make_DATA  (yytext, yy::location());  }
<*>.|\n    { return yy::parser::make_DATA  (yytext, yy::location());  }

%%

void Driver::scan_begin (const std::string &f) {
  yy_flex_debug = trace_scanning;
  yy_scan_string(f.c_str());
//  yyin = std::istringstream(file);
  
//   if (file.empty () || file == "-")
//     yyin = stdin;
// else if (!(yyin = fopen (file.c_str (), "r")))
//     {
//       std::cerr << "cannot open " << file << ": " << strerror (errno) << '\n';
//       exit (EXIT_FAILURE);
//     }
}

void Driver::scan_end () {
  fclose (yyin);
}
