#include <iostream>
#include "gtest/gtest.h"

class Tests :  public ::testing::Test {
	
};

TEST_F(Tests, test) {
	if (getenv("REGRESSION_FAIL")) {
		EXPECT_EQ(0,1);
	} else {
		EXPECT_EQ(0,0);
	}
}
 
int main(int argc, char **argv) {
	::testing::InitGoogleTest(&argc, argv);
	return RUN_ALL_TESTS();
}
