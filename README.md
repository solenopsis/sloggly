SLoggly
======

SLoggly is a class (and eventually an AppExchange app) for logging to [Loggly](http://loggly.com) from Salesforce APEX classes.

Features
-------------
* Custom settings for setting Loggly URL
* Support for on the fly batch logging _(see examples)_
* JSON logs in Loggly [[1](http://loggly.com/blog/2011/06/on-the-way-to-impressive/)]

Examples
--------------

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