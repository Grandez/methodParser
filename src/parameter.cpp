/*
 * Parameter.cpp
 *
 *  Created on: 30 ago. 2020
 *      Author: Javier
 */

#include <parameter.hpp>
#include <string>


Parameter::Parameter(std::string name) {
	this->name = name;

}

Parameter::~Parameter() {
	// TODO Auto-generated destructor stub
}
void Parameter::setValue (std::string val) {
	value = val;
}

