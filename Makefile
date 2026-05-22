all:
	nvcc main.cu -o image_processing

run:
	./image_processing

clean:
	rm -f image_processing output.txt