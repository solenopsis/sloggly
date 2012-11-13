SLoggly
=======

SLoggly is a class (and eventually an AppExchange app) for logging to [Loggly](http://loggly.com) from Salesforce APEX classes.

Features
--------
* Custom settings for setting Loggly URL
* Support for on the fly batch logging _(see examples)_
* JSON logs in Loggly [[1](http://loggly.com/blog/2011/06/on-the-way-to-impressive/)]

Setup
=====
Configure Loggly
----------------
* Create a [new input](http://loggly.com/support/sending-data/input-basics/) in Loggly that is HTTPS and json

     ![Loggly Input](http://i.imgur.com/Lk6E3.png "Loggly Input")

* Copy your input URL from the input page

Configure Salesforce
--------------------
* Add Loggly to your allowed remote sites
     * Setup -> Secrity Controls -> Remote Site Settings
     * Click New Remote Site
     * Name it "Loggly"
     * Set the Remote Site URL to "https://logs.loggly.com"

     ![remote sites config](http://i.imgur.com/BFGcb.png "remote sites config")

* After deploying the Custom Settings object and the Loggly class file, add a new Loggly custom setting
     * Setup -> Develop -> Custom Settings
     * Click Manage next to Loggly
     * Click New
     * Name it "default" and enter in you URL from the [Loggly Configuration](#configure-loggly) section
     * Then set the other custom parts to the logging

     ![sloggly config](http://i.imgur.com/WNR1A.png "sloggly config")

Examples
========

**Single Log**

    Loggly.singleLog('Error Message', DateTime.now(), 'LEVEL');

**Batching Logs**

    //Enable batching
    Loggly.BATCH_LOGS=True;
   
    //Create new instance of the Loggly class
    Loggly l = new Loggly();
   
    //Batch a message
    l.add('Error Message', DateTime.now(), 'LEVEL');
   
    //Any calls to Loggly.singleLog after setting BATCH_LOGS will automatically be batched and sent with the .flush
   
    //Flush the message queue
    l.flush();

**Screenshot from Loggly**

![Screenshot](http://i.imgur.com/lh7rn.png "Example")