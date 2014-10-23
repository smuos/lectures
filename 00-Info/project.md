Shell Project
=============

## Overview
Your team's goal is to build a unix Shell.  
Each team will have 4 members where possible.  
All work will be done on GitHub.  

## Grading
30% of the projects marks will be assigned by ~~end of October~~ early November.  
The remaining 70% will be assigned on final submission at the end of term.  
This final submission will be a written report and a presentation/demo to the class.  

## First Report
> Due Friday November 7th at 11:59pm

- Summary of the features planned and strategies.  
- Detail work accomplished to date.  
- Around two pages double spaced.

## Final Submission
> Due on the last day of classes.

- Written report of completed work.
- A demonstration of the completed work.  
- Between 2 and 4 pages double spaced.


# Features
Here is an incomplete list of possible features to add to your shell:  

## Piping
Enable your shell to connect the output of one program to the input of another.
```bash
ls -l | grep .pdf | less
```

## History
Have your shell keep track of commands the user as typed.
```
user$ ls
user$ cd
  <arrow up>
user$ cd
  <arrow up>
user$ ls
```

## Tab completion
Hitting <tab> in your shell will suggest commands that match your partial command.
```
user$ wg <tab>
user$ wget
```

## Redirection
Redirect input or output of commands from or to files.
```bash
ls -l | grep *.pdf > pdfLog.txt
```
