/*
 * Parameter.hpp
 *
 *  Created on: 30 ago. 2020
 *      Author: Javier
 */

#ifndef SRC_PARAMETER_HPP_
#define SRC_PARAMETER_HPP_

#include <string>


class Parameter {
public:
	std::string name;
	std::string value;
	Parameter(std::string name);
	virtual ~Parameter();
	void setValue(std::string val);
};


#endif /* SRC_PARAMETER_HPP_ */
