Telegram bot
========

This program is a telegram-bot, which will help you pass Other laboratory work at the university on time, so that you have successfully completed this course.

The main task of the bot to remind you what subjects and how much laboratory work, you should have handed over today to not give you relax.

Boat based on the data you have entered the start and end of the semester, the number of today's date and the lab should roughly suggests how Other laboratory work you would have to have to pass.

##### Examples of commands:

```
> /Start

< Hello. I can help you pass all the labs to the nurse did not swear. See a list of what I can do:
* /Semester - remembers the beginning and end of the semester dates
* /Subject - object and adds the number of laboratory work on it
* .....
```

```
> /Semester

< When starting to learn?
> 09/01/2016

< When it is necessary to pass all the labs?
> 25/11/2016

> Realized at all about all we have 2 months and 24 days.

```

```
> /Subject
< What is the subject of teaching?
> OAiP
> How many labs must pass?
< 7
> OK

> /Subject
< What is the subject of teaching?
> KPiYaP
> How many labs must pass?
< 5
> OK
```

```
> /Status

< By this time you should have been commissioned:
> OAiP - 3 7
> KPiYaP - 2 out of 5
>
> Let's pull devil!
```

"Bot able to remember what items you passed. To do this, add the command '/submit', which can also be activated by the message 'I have passed'. After the activation of the command you to come all your items separate _press_. In the example of the button will show through the brackets. Once you have selected the object name, it sends you a new key to all numbers of the remaining labs.

##### Examples of commands:

```
> /Submit

> What gave?
> [OAiP]
> [KPiYaP]
>
> KPiYaP
>
> What is the lab?
> [1]
> [2]
> [3]
> [4]
> [5]
>
> 1
>
> Viewtiful!
```

```
> I passed

> What gave?
> [OAiP]
> [KPiYaP]
>
> KPiYaP
>
> What is the lab?
> [2]
> [3]
> [4]
> [5]
>
> 3
>
> Viewtiful!
```

Your bot sends you Telegram timer (every 1 day, every 2 days, once a week on Fridays) with a list of all reminders that you will not put.