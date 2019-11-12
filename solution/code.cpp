#include "archlab.hpp"
#include <stdlib.h>
#include <getopt.h>
#include "microbenchmarks.h"
#include <iostream>
#include<string.h>
#include<unistd.h>
#include <boost/program_options.hpp>
namespace po = boost::program_options;

int main(int argc, char *argv[]) {

	
	uint64_t magic;
	archlab_add_option<uint64_t>("magic",  magic, 4096 ,  "magic number.");
	archlab_parse_cmd_line(&argc, argv);

	{
		ArchLabTimer timer; // create it.
		timer.
			attr("magic", magic). 
			attr("Method", "test"). 
			go();
		std::cout << "Hello world!\n";
		
		sleep(1);
	}
	archlab_write_stats();
  
	return 0;
}

