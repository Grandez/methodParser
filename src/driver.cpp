/* Driver for calc++.   -*- C++ -*-

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

#include <driver.hpp>

#include "methodParser.hpp"
#include "parameter.hpp"


Driver::Driver () : trace_parsing (false), trace_scanning (false) {
}

int Driver::parse (const std::string &f) {
  file = f;
  location.initialize (&file);
  scan_begin (f);
  yy::parser parse (*this);
  parse.set_debug_level (trace_parsing);
  int res = parse ();
  scan_end ();
  return res;
}


Driver * Driver::addParameter (Parameter *parm) {
	// if (signature == NULL) signature = vector(method::Parameter *);
	signature.push_back(parm);
	return (this);
}

//void Driver::scan_begin() {
//	yy_flex_debug = trace_scanning;
//	if (file.empty () || file == "-")
//		yyin = stdin;
//	else if (!(yyin = fopen (file.c_str (), "r"))) {
//		std::cerr << "cannot open " << file << ": " << strerror (errno) << ’\n’;
//		exit (EXIT_FAILURE);
//	}
//}

