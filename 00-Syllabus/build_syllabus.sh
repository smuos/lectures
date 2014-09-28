#!/bin/bash

pdflatex csci3431.course.outline.2014.tex
bibtex csci3431.course.outline.2014

pdflatex csci3431.course.outline.2014.tex
pdflatex csci3431.course.outline.2014.tex

open csci3431.course.outline.2014.pdf
