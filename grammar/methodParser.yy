/* Parser for calc++.   -*- C++ -*-

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

%skeleton "lalr1.cc" // -*- C++ -*-
%defines

%define api.token.raw

%define api.token.constructor
%define api.value.type variant
%define parse.assert

//JGG
// %define api.namespace { method }

%code requires {
  #include <iostream>
  #include <string>
  #include "parameter.hpp"
  using namespace std;
  
  class Driver;
}

// The parsing context.
%param { Driver& drv }

%locations

%define parse.trace
%define parse.error detailed
%define parse.lac full

%code {
#include "driver.hpp"
#include "parameter.hpp"

Parameter *parm = NULL;

}

%define api.token.prefix {TOK_}

%token <std::string> DATA
%token <std::string> COMMA
%token <std::string> LPAR
%token <std::string> RPAR
%token <std::string> ASSIGN
%token <std::string> STRING

%nterm <Parameter *> signature
%nterm <Parameter *> list_parms
%nterm <Parameter *> parm_decl
%nterm <std::string>         data

%printer { yyo << $$; } <*>;

%%
%start method;

// Un fichero fuente es un conjunto de declaraciones o nada
method: LPAR signature RPAR
 

signature: list_parms
         | %empty            { }
         ;

list_parms: parm_decl                    { drv.signature.push_back(parm); }   
          | list_parms COMMA parm_decl   { drv.signature.push_back(parm); }
          ;
          
// Las declaraciones son cada uno de los tipos de sentencias

         
parm_decl: data                   { parm = new Parameter($1); } 
         | parm_decl ASSIGN data  { parm->value = $3;         }
         ;

data: DATA                 
    | STRING                                
    | LPAR data RPAR       { $$ = $1 + $2 + $3; }
    ;                  

%%

void yy::parser::error (const location_type& l, const std::string& m) {
  std::cerr << l << ": " << m << '\n';
}





          
