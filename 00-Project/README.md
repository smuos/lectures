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

Each student must submit the following two documents to [moodle](http://moodle.cs.smu.ca/).
Please ensure everyone in your group sends the exact same pdf copy of the final report.
This may seem unnecessary, but it puts the responsibility of the students grade in their own hands.

__Report__
- Written report of completed work.
- Focus on what makes your shell unique.
- Discuss the challenges, and decisions you had to make.
- Between 700 and 1000 words.

__Peer Evaluation__

Each student must fill out a peer evaluation form.
These can be found as a pdf on the [moodle](http://moodle.cs.smu.ca/).


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

Resources
=========

The following is an in development list of resources that may prove useful.  
Please feel free to fork and add additional links and comments.  

UNIX
----

[The UNIX Time-sharing system](https://dl.acm.org/citation.cfm?id=361061)  

[Early Bell System Technical Journals on UNIX](http://www3.alcatel-lucent.com/bstj/vol57-1978/bstj-vol57-issue06.html)  

[Video: The UNIX Operating System](http://youtu.be/tc4ROCJYbm0)  

[Bash Architecture](http://aosabook.org/en/bash.html)
