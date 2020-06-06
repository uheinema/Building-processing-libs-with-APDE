# How to create Processing libraries out of your existing sketch (using [APDE](#apde))

## Prereqisites


> Warning!
All this applies to APDE `0.51` only, `0.52 pre1` will not work! That's why it is pre1... 

Set up APDE to
1. Build on internal storage - OFF
2. Keep build folder - ON

Let's asume we are not creating a lib from scratch, but already have a sketch containing some useful classes.

 Just as examples for the follwing step I have prepared LIB_start.pde.
 
 > If you want to follow the tutorial, DON'T install this into Processing (or deinstall), or you would have a working package installed, leading to general confusion.  
 Or just pick your own library/package name.
 
 The goal here was to have something simple, but not trivial - code like you would write every day (I purposely added a pitfall or two, but nothing really constructed in an inrealistic way)
 
 Have a look at
 
 ## LIB_start.pde
 
 Nothing too fancy, should look like
 
 ![This](Screenshot_20200526_190148_com.calsignlabs.apde.sketchpreview.jpg)
 
 It is .pde now, not .java, and that is similar, but not identical.
 
We first have to 'javaize' it and create an appropriate package. If you have done that already, skip to [creating the library]( #creatingthelibrary ) _Link not working. Just scroll down or use the index_

## Creating the package

 The Indicator class could be the base for a library that can be used in other sketches. So we want to make parts it a library, lets call it `MyStuff`.
 
 We also have to decide on a package name, can be pretty anything, lets use `my.cool.stuff`.
 
 > When recreating the tutorial examples use your own names!
 
 So our goal is to
 - add `import my.cool.stuff;` to the beginning of our sketch  
 -make all beyond  
  `/****** end of main sketch *******/`  
  into a library.
  
### Source mangling, step 1

To do that, first split it up into individual files for each class, for now
 - LIB_step1.pde (the rest of the main sketch)
 - Indicator.pde
 - SquareIndicator.pde
 - BlobIndicator.pde
 - FloatAdapter.pde
 
 ### LIB_step1
 
There should arise no problems, so we start creating the .java files - there might be a few things to change, how much depends on the nature of your code.

- Processing is 'rewriting' your code into java, actually, changing/adding a few things.
- It is then , together with some other things, concatenated into one large java file. If using APDE, it can be located after a build at  

`build/src/processing/test/lib_step1/LIB_step1.java` (note the case mixing)

Let's have a look what is there:

```Java

package processing.test.lib_step1;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class LIB_step1 extends PApplet {
...
```

1. The line   
`package processing.test.lib_step1;`  
  was added at the start. 
2. A whole bunch of import statements was added - we will.come back to them soon.
3. The class declaration of where your code really lives:
```Java
public class LIB_step1 extends PApplet {
```
 This is where all those nice thing like println and abs and loadStrings and rect are coming from, and if you use them, we will have to make them available to the library modules - later.

4. What follows is our code, with all undecorated methods having `public` added, and a few more subtle changes.

We could now copy from there (thus skipping/simplifying the separation step above), but going through your code at this point and deciding which things should be private or public and explicitely stating so might be a good idea, if not already done - and while at it, document all public methods.  
Analyzing the errors will show us how and why things are different in .java - we will need to know when maintaining the library!

At the same time, you may add the obviously needed `import` statements - you could copy the whole lot, but I suggest to sort it out - will give you some insight into your real dependencies.

See whether it still compiles/runs. 
It should. Find it in

### LIB_step2

Now make a backup.
Make a copy.
Make another backup.
Have a coffee.

## From milk to coffee

And now we really make it into .java....

Be warned: You will look at a LOT of compiler errors soon - most pretty automatic to fix, some not so, as they require design decisions regarding the interface to the library.
> Shut down your IDE, whatever it is, before the next step. Eg. APDE would recreate the .pde if you steal/rename it while it is still running - it's a feature, but not wanted now. If things get weird, it is always a good idea to check whether you  have both a .java. and a .pde - you shouldn't, unless on purpose, and even then I would not recommend it.

Now
1. Rename all the files of your library-to_be from .pde to .java
2. Add 
`package my.cool.stuff;` 
to the start of each file.

3. For now, comment out all of your main sketch. It would just add to the stack of error messages, and most would be in consequence of the package not existing yet.

4. Compile and ...oops!

### LIB_java1

Lots(20) of errors, ~~all~~most expected.

At this point, consider temporarily removing some/most non-essential classes (rename from .java to .java.xxx. Again, with IDE not running...), if you have a large number of them.
If your classes have circular references, it may ne neccessary to remove them until one of the classes can be build.

> Wish I had known this modus operandi when trying to do this for the first time.  
17 classes, not trivial at all, clueless.  
Imagine how much fun I had.

We will do that, leaving only `FloatAdapter.java` for now, as it does not depend on anything else.

Compile...fine, no problems.
Reactivate `Indicator.java`.

Only 4 errors...lets see
```
1. ERROR in /storage/emulated/0/build/src/
 package my/cool/stuff;/Indicator.java (at line 12)
	class Indicator implements FloatAdapter<Indicator> { // almost an interface
	                           ^^^^^^^^^^^^
FloatAdapter cannot be resolved to a type
```
What's that? Oh, I forgot to put `package my.cool.stuff;` into FloatAdapter.java, and as it is not in the same package as `Indicator`, it can't be found.
> If you look into build/src/ now or later, you will find `build/src/ package my/cool/stuff;/FloatAdapter.java`, space and semicolon included...and later on multiple directories, all with the ~~SAME~~similar name...go figure, ~~I can't. ~~
PS: It happens when there are spaces or empty lines in front of the `package` statement. Funny that that works,  filenames starting with spaced and ending in semicolons, but it does.  
We won't need those files anyhow, they are just copies.

Onwards:
```
1. ERROR in /storage/emulated/0/build/src/
package my/cool/stuff;/Indicator.java (at line 33)
	x=int(xx);
	  ^^^
Syntax error on token "int", delete this token
```
Yep, casting/type conversion is done differently in .java.
Look at the src in build:
```
    x=PApplet.parseInt(xx);
```
Ok, we will be referencing PApplet/PGraphics anyhow, make it so...

And we need 
```
import processing.core.PApplet;
```
Fine, leaves
```
1. ERROR in /storage/emulated/0/build/src/
package my/cool/stuff;/Indicator.java (at line 46)
	return map(value, 1.0*mini, maxi, 0, 1.0);
	       ^^^
The method map(float, double, float, int, double) is undefined for the type Indicator
```
Right, fortunately that is in PApplet, too:
```
return PApplet.map(value, 1.0*mini, maxi, 0, 1.0);
```
and we get

```
1. ERROR in /storage/emulated/0/build/src/
package my/cool/stuff;/Indicator.java (at line 46)
	return PApplet.map(value, 1.0*mini, maxi, 0, 1.0);
	               ^^^
The method map(float, float, float, float, float) in the type PApplet is not applicable for the arguments (float, double, float, int, double)

```
Excuse me? Oh, yes, the default type for floating point literals iis double in .java and float in .pde. The generated source reads
```
return map(value, 1.0f*mini, maxi, 0, 1.0f);
  }
```
Of course I provoked this one, but good to know, isn't it?

We now could go to our main sketch and activate
```Java
import my.cool.stuff.*;

Indicator frate, frame, imousex;
```
only to see whether we can access our package.

Well, we can, up to a point:
```
1. ERROR in /storage/emulated/0/build/src/processing/test/lib_java3/LIB_java3.java (at line 36)
	Indicator frate, frame, imousex;
	^^^^^^^^^
The type Indicator is not visible
```
Right again, it is in a different package, and has to be `public` there..
```
public class Indicator implements FloatAdapter<Indicator> { // almost an interface
```
Bingo, ignore the warnings.

On to SquareIndicator...and we immediately see we have a problem:
While map() is a static function, fill/rect are not..actually, they are just convenience wrappers of g.fill() etc
And later on we might want to draw into another PGraphiics.
We now have to decide:
- pass `this` or `this.g` to the constructor and remember it in an instance variable?
- pass this.g to the draw() method, as it is the only place which needs to know
- ....


Let's use the second option.

 
And in Indicator.java of course
```Java
...
import processing.core.*;
...
abstract public void draw(PGraphics g);
...
```
Along the way, there also is
```
. ERROR in /storage/emulated/0/build/src/package my/cool/stuff;/SquareIndicator.java (at line 10)
	g.fill(#ff7777);
	       ^
Syntax error on token "Invalid Character", delete this token
```
In .java use 0xff instead of #, the high byte is the transparency (and setting that to 0xff is pretty much all color is doing)

Finally  `SquareIndicator.java` looks like
```Java
package my.cool.stuff;

import processing.core.PGraphics;

public class SquareIndicator extends Indicator {
  public SquareIndicator() {
  }; 
  public void draw(PGraphics g) {
    float part=u()*w; 
    g.fill(0xffff7777);
    g.rect(x, y, part, h);
    g.fill(0xff00ff77);
    g.rect(x+part, y, w-part, h);
  }
}
```

Not too bad,  should have been that way before going to .java

Compiles OK, too!!

With this API change, sketch.pde needs to be changed to:
```Java
  frate.set(frameRate).draw(g);
  frame.set(frameCount).draw(g);
  imousex.set(mouseX).draw(g);
```
so while at it, why not activate everything except the `BlobIndicator`?

```
1. ERROR in /storage/emulated/0/build/src/processing/test/lib_java3/LIB_java3.java (at line 53)
	imousex.value=mouseX=width/3;
	        ^^^^^
The field Indicator.value is not visible
```

Right again. So make it `public`...or wait, what are we doing with it? Do we really want to assign to it this way? 
Better to use getters/setters here, so
```Java
imousex.set(mouseX=width/3);
```
or throw it out, I just added it to provoke this error.

Run and..

![Screenshot_20200526_190115_com.calsignlabs.apde.sketchpreview](Screenshot_20200526_190115_com.calsignlabs.apde.sketchpreview.jpg)

Hurray! Running, now `BlobIndicator.java`...

And there are obvious problems, again:

- color cannot be resolved to a type
- The method color(int, int, int, int) is undefined for the type BlobIndicator

Yep, color is.more Processing ~~obfuscation~~comfort,  the generated source just makes it an int. Good enough for us, but
```
----------
1. ERROR in /storage/emulated/0/build/src/
package my/cool/stuff;/BlobIndicator.java (at line 12)
	int blobcolor=PApplet.color(20, 20, 20, 100);
	              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Cannot make a static reference to the non-static method color(int, int, int, int) from the type PApplet
```

So why is it non-static? Urgh, HSB vs. RGB...
There are other functions to do that, or we could write our own one-liner, but for now let's use a constant like

`int blobcolor=0x64141414;`

and march on:

```
1. ERROR in /storage/emulated/0/build/src/
package my/cool/stuff;/BlobIndicator.java (at line 21)
	pic=loadImage(picname);
	    ^^^^^^^^^
The method loadImage(String) is undefined for the type BlobIndicator
```
or non-static in PApplet - another API change is due, either
```
BlobIndicator(PApplet me,String picname){
    pic=me.loadImage(picname);
  }
```
or
```
 BlobIndicator(PImage _pic){
    pic=_pic;;
  }
```
I'll use the second one, and with 
```Java
package my.cool.stuff;

import processing.core.*; 

public class BlobIndicator extends Indicator {
  int blobcolor=0x64141414;
  //PApplet.color(20, 20, 20, 100);
  PImage pic;
  public BlobIndicator() {
  };
  public BlobIndicator(int blc) {
    blobcolor=blc;
  };
  public BlobIndicator(PImage _pic){
    pic=_pic;
  }
  public void draw(PGraphics g) {
    if (pic!=null) {
      g.image(pic, x, y, w, h);
    } else {
      g.fill(50);
      g.rect(x, y, w, h);
    }
    g.fill(blobcolor);
    g.rect( x, y, (u()*w)%w, PApplet.constrain(u()*h, 0.0f, h));
  }
}
```
and in `sketch.pde`
```Java

/*

 java_final for 
 
 How to create a library out of your sketch
 using APDE

 */
 
import my.cool.stuff.*;

Indicator frate, frame, imousex;

void setup() {
  fullScreen(P3D);
  // create some indicators
  frate=new SquareIndicator()
    .box(100, 100, width-200, 100)
    .range(1, 90);
  
  frame=new BlobIndicator(loadImage("smile.png"))
    .box(100, 300, width-200, 1000)
    .range(0, 500);
   
  imousex=new SquareIndicator()
    .box(100, height-400, width-200, 100)
    .range(0, width);
  imousex.set(mouseX=width/3);
}


void draw() {
  background(frameCount%128);
  stroke(0);
  // set new values, draw them
  frate.set(frameRate).draw(g);
  frame.set(frameCount).draw(g);
  imousex.set(mouseX).draw(g);
}
```

we have created our package!

### LIB_java_final

## Creating the library

### Creating the template

You can create the folder from scratch or (recommended);

#### Use any existing (simple) library as a template:
- find one in `Sketchbook/libraries`
- make a copy, call it `MyStuff`
- delete or clear all subdirectories (in the copy only!). You can keep library, library-dex, src, examples... but make sure to replace contents with your own
- rename/edit/delete/create things like revisions.txt as per Processing rules
- write at least a README.md (ok, later..:-)


### Creating the JAR

class JAR extends ZIP....and inherits its constructor, too!.

So basically all we need to do is create a .zip with the extension .jar, put our package directory structure containing the compiled .class files into it, and we are done. No 3GB IDE needed.

All the rest is exlained at
 [the official place.](https://docs.oracle.com/javase/tutorial/deployment/jar/manifestindex.html)
 
 As they correctly say
> JAR files support a wide range of functionality, including electronic signing, version control, package sealing, and others. What gives a JAR file this versatility? The answer is the JAR file's manifest.
 
 Do we need this verstupidity? 
 Not at all, and we don't even need a dummy manifest, luckily.
 
#### No MANIFESTS! 
#### Down with XMLism! 
#### Nurse!

Excuse me.. where were we? Ah, yes!

Almost there:

After a successful build, I can find the compiled packet .class files at 
`build/bin/classes/my/cool/stuff/...`
On other platforms, search for Indicstor.class ...

What we need is a `MyStuff.jar` like
-  MyStuff.jar
 - -- my
  - --- cool
   - ---- stuff
    - ...
    
located in 
`Sketchbook/libraries/MyStuff/library/`

So create a .zip and copy/rename.
Or, and this is what I do,  just copy  into an existing .jar (already in the right place) with a tool capable to do so (`TotalCommander`).

This is needed when your library sources don't reside all in one sketch, anyhow.

## Are we done, yet?

Effectively yes. 
And no.

Zip the directory MyStuff into MyStuff.zip,  and it should be installable with Processing...but before you do, test it (without having to go through the packaging/installation routine).
> Android/APDE need(?) the .jar in a DEXed form, too.  
Fortunately, APDE comes with a build-in DXter, see below. (Tbw..@Calsign might change/simplify how that works with the upcoming release anyhow)



## Does it work?

Let's see...

### To dex, or not to dex

With APDE/Android you first have to (re-)dex the .jar to create a Dalvik EXecutable. (No, I won't explain why and what that is here. Look at (https://android.googlesource.com/platform/dalvik/+/a9ac3a9d1f8de71bcdc39d1f4827c04a952a0c29/dx/src/com/android/dx/command/dexer/Main.java))
Oops. 


> The dx tool lets you generate Android bytecode from .class files. The tool converts target files and/or directories to Dalvik executable format (.dex) files, so that they can run in the Android environment. It can also dump the class files in a human-readable format and run a target unit test. You can get the usage and options for this tool by using dx --help.

Note that this has to be done each time you modify the .jar!

You can do that with the APDE Library Manager, fine for now. Try it. 

~~Instructions there.~~

Or automat the somewhat tedious process by

### Create a Termux redex command

1. Install [Termux](https://termux.com/)
2. Start termux.
3. Run  
`termux-setup-storage`  
and grant access.
4. Install dx  
`pkg install dx`
5. Create a file like ( or use redex.txt)
```Bash
#!
# redex libname
# - run dx to update an APDE Processing library
cd storage/shared/Sketchbook/libraries/$1
dx --dex --output=library-dex/$1-dex.jar library/$1.jar
#
```
6. Send this file to Termux, calling it 'redex'. Ignore funny message.
7. Copy it to your Termux home   
 `cp downloads/redex .`
8. Make it executable
 `chmod +x redex`
 
 From now on, you can start a Termux session and  
 `./redex MyStuff`  
to (re-)create the dexed library.

Try it.
No news is good news.


### Got DEX, will test!

Done?

Create a new sketch, let's call it `Mytest`.
Put the `sketch.pde` from LIB_java_final  into the new sketch folder, don't forget to copy 'data/' ( or do, and see what happens...better postpone that till later)

Run it.

Does it work?

### Example given

Congratulations, you build a library for Processing and are already using it.

And this has just become your first example, so copy it into `library/MyStuff/examples/example1`.
It should now be visible (and useable) in your IDE under `Library Examples/'MyStuff/example1'.

> When only one example exists or there is a .pde in the library root Processing may open that automatically. But you will have more than one example anyhow.

Test it.

Zip Sketchbook/libraries/MyStuff, and it can be installed like any other zipped library.

- [ ] Check documentation and examples
- [ ] Put it on GitHub.
- [ ] ...

## Maintaining/changing the library

Expanding/testing in general should.be done where the library sources are kept.
Changes can be tested immediately this way, as local package members override the ones in installed libraries (Q: Is this always/everywhere the case??).
When done, and before you can use it with other sketches, of course the .jar/-dex.jar must be recreated as above.

This also means that for punctual changes or addition of new classes in large libraries only the .java files for the classes to be changed need to be copied to a sketch folder for development and unit testing, and can be later - or not at all - integrated into the complete library.

----

## APDE

 [APDE](https://github.com/Calsign/APDE/wiki/Getting-Started)

All code here was written ( if not copied from elsewhere ), edited and tested with APDE, and APDE only, on a cell phone, single-finger typing...I might explain why on another day.

Praise Calsign!

Also, the .jar and .jar-dex libraries here where created with APDE - after all, that was the point of the whole exercise.

## License

```Java
/***************************************************************************************
 * 
 * How to create Processing libraries out of your existing sketch (using [APDE](#apde))
 * Copyright (c) 2020 by the author
 * @author Ullrich Heinemann , https://github.com/uheinema
 *
 * All rights reserved. 
 * Released under the terms of the GPLv3, refer to: http://www.gnu.org/licenses/gpl.html
 ***************************************************************************************/
```
 
 
 
 


-----

