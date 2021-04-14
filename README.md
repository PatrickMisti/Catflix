# Catflix

Netflix without payment. The idea behind is to see all your favorite series without to pay anything 
like Netflix and co. I want to watch all my series that I am interested and also save the state, what 
I watch at least. 

The main problem was always when I opened the internet explorer, I had so many tabs open because I always had the
see the very latest episodes of a series. After a long time my safari accumulated. Sometimes I saw 
an episode and my internet explorer on my phone crashed. So the idea was to manage my  series and 
always to see the latest one.

## Toolstack - Controlling

Catflix is an open-source software for android and ios. In this chapter are all used libraries for 
this solution, attached how I used it and a link how to find the documentation to each one. The 
documentation is filled with introductions and images, so that everyone understood how to build 
exactly the same project on his/her own.

### Floor 
needed dependencies :
- [sqflite](https://pub.dev/packages/sqflite)
- [floor](https://pub.dev/packages/floor)

To build the floor boilerplate code use:

* flutter packages pub run build_runner build 
or
* flutter packages pub run build_runner watch

#### Database Testing
* toMap correct
* database test Series
* database test Category
* database test SeriesCategoryHistory

### Http and Html from pub.dev
needed dependencies:
- [http](https://pub.dev/packages/http)
- [html](https://pub.dev/packages/html)

To get data from website you need http for fetching data and html do go throw the xml file

#### Http and Html Testing
* data save in db
* save more data in db
* save data in db but with error building

Validated url witch the user selected from explorer. Also validated if url is empty or even exists in db.
If the series is from serien.sx and you save the exactly same series from anicloud.sx for example. Then 
it is redundant but I hope that my users are smart enough not to save a series twice.

## View




