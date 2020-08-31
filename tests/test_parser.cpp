/*
 * test_parser.CPP
 *
 *  Created on: 31 ago. 2020
 *      Author: Javier
 */

#include <iostream>
using namespace std;

#include "driver.hpp"

#include "gtest.h"

TEST(parserMethod, cases) {
	Driver driver;
	EXPECT_EQ(0, driver.parse("(1,2,3)");
}

int main (int argc, char **argv) {
   ::testing::InitGoogleTest(&argc, argv);
   return RUN_ALL_TESTS();
}
