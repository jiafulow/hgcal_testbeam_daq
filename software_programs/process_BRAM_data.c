// Framework for basic BRAM reading and writing with processor speed tests
// Includes userspace UIO driver
// Compatible with hardware design: DAQ_Design_1   	

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>
#include <string.h>

#define BRAM_MAP_SIZE 		0x2000
#define BRAM_DATA_OFFSET 	0x00

// GLOBAL VARIABLES
int fd;
void *ptr_BRAM;
int *ptr_baseline;
clock_t begin, end;
const char *filepath = "/home/BRAM_data.txt";
int num_iterations = 1000;
//int max_partitions = BRAM_MAP_SIZE/4;
int max_partitions = 1;

int readtest_out, writetest_out;
int baseline_readtest_out, baseline_writetest_out;

//MAIN FUNCTION
int main(void)
{	
	FILE *fp = fopen(filepath, "ab");
	int readtest(int num_iterations, int scale_factor, void *src);
	int writetest(int num_iterations, int scale_factor, FILE *output_file, void *src);

	// USERSPACE UIO DRIVER FOR BRAM
	ptr_BRAM = malloc(BRAM_MAP_SIZE);
	fd = open("/dev/uio0", O_RDWR);
	if (fd < 1){
		fprintf(stderr, "Invalid UIO device file.\n");
		return -1;
	}
	ptr_BRAM = mmap(NULL, BRAM_MAP_SIZE, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	
	// PTR FOR RUNNING BASELINE TESTS
	/* 
	ptr_baseline = malloc(BRAM_MAP_SIZE);
	int j;
	for (j = 0; j < BRAM_MAP_SIZE/4; j = j+1)
	{
		ptr_baseline[j] = j;
	}
	*/

	// LOOP OVER A RANGE OF DATA SIZES
	int i;
	for (i = 1; i <= max_partitions; i = i*2)
	{
		//readtest_out = readtest(num_iterations, i, ptr_BRAM);
		writetest_out = writetest(num_iterations, i , fp, ptr_BRAM);
		//baseline_readtest_out = readtest(num_iterations, i, ptr_baseline);
		//baseline_writetest_out = writetest(num_iterations, i, fp, ptr_baseline);
	}
	
	// CLOSE FILES AND UNMAP BRAM
	fclose(fp);
	munmap(ptr_BRAM, BRAM_MAP_SIZE);

	return 0;
}

// READTEST FUNCTION
int readtest(int num_iterations, int scale_factor, void *src)
{

	/* Tests processor speed for reads using memcpy. Performs num_iterations reads of size
	   (BRAM_MAP_SIZE)/(scale_factor) and computes and prints the average time per read. */

	int i;
	void *test_ptr;
	test_ptr = malloc(BRAM_MAP_SIZE);
	double read_time;
	begin = clock();

        for (i = 0; i < num_iterations; i = i+1)
        {
        memcpy(test_ptr, src, (BRAM_MAP_SIZE)/(scale_factor));
        }

        end = clock();
        read_time = (double)(end - begin) / (num_iterations*CLOCKS_PER_SEC);
	printf("memcpy time = %f\n", read_time);
	return 0;
	}

// WRITETEST FUNCTION
int writetest(int num_iterations, int scale_factor, FILE *output_file, void *src)
{
	/* Tests processor speed for reads and file writes using fwrite. Performs num_iterations writes of 
	   size (BRAM_MAP_SIZE)/(scale_factor) to location output_file and computes and prints the average 
	   time per write. */

	int i;
	int fwrite_out;
	double write_time;
	begin = clock();
	
        for (i = 0; i < num_iterations; i = i+1)
        {       
		fwrite_out = fwrite(src, (BRAM_MAP_SIZE)/(scale_factor), 1, output_file);
		if (fwrite_out != (1)) {perror("FWRITE ERROR");}
	}
	
	end = clock();
	write_time = (double)(end - begin) / (CLOCKS_PER_SEC * num_iterations);
        fprintf(stdout, "fwrite time = %f\n", write_time);

}	


