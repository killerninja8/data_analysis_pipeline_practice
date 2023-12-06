# Makefile
# Author: Siddharth Grover
# Date: December 5, 2023

# This Makefile automates the data analysis pipeline and report generation for the given text files. 

#Why this makefile is "smarter" - it does the same thing as the run_all.sh, uses wildcards for easier writing, runs by typing only one phrase. To top that off, it also opens the index.html file, tells you all the steps in the process with echo, to save you the effort of changing to the _build directory and using open index.html. 

# Target
all: report/_build/html/index.html open_report


# Dependencies (helps avoid typos)
data_files = data/isles.txt data/abyss.txt data/last.txt data/sierra.txt
result_files = results/isles.dat results/abyss.dat results/last.dat results/sierra.dat


# Rules (using wildcards)
# Reference: https://earthly.dev/blog/using-makefile-wildcards/
results/figure/%.png : scripts/plotcount.py results/%.dat
	python scripts/plotcount.py --input_file=$< --output_file=$@

$(result_files) : scripts/wordcount.py $(data_files)
	python scripts/wordcount.py --input_file=$< --output_file=$@

report/_build/html/index.html : report/count_report.ipynb report/_toc.yml report/_config.yml $(wildcard results/figure/*.png)
	jupyter-book build report 

open_report:
	@echo "Running Analyses..."
	@echo "Completing Analyses..."
	@echo "Building HTML Report..."
	@echo "Opening HTML report..."
	@open report/_build/html/index.html 

clean :
	rm -f $(result_files)
	rm -f results/figure/*.png
	rm -rf report/_build
