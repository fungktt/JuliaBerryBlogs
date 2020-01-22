# A blog on using Julia to control LEDs on a Raspberry Pi

Hello there! If you are reading this, you're probably wondering how you can turn LEDs on and off here on the Raspberry Pi not the regularly-used Python that everyone knows, but rather Julia.
Today, we're going to talk about how we can control physical objects via the onboard GPIO. We are going to first do a single circuit with one LED blinking, followed by two circuits with two LEDs blinking alternatively.

![8](https://user-images.githubusercontent.com/28962234/72093584-8e679a80-330c-11ea-8e69-e1f9bdc7c020.jpeg)

This is the circuit we are trying to build: (The image is from [Wikimedia Commons](https://commons.wikimedia.org/wiki/File:Raspberry_Pi_LED.png) and is licensed under [CC BY-SA](https://commons.wikimedia.org/wiki/File:Raspberry_Pi_LED.png#Licensing).)

![circuit](https://upload.wikimedia.org/wikipedia/commons/d/d6/Raspberry_Pi_LED.png)

## Chapter 1: Installing Julia and PiGPIO.jl

First, grab your Raspberry Pi. Turn it on and open Terminal. Once you're there, type the following:

```
sudo apt install julia
```

This should grab you the version 1.0.3, which is enough for this case. (I know it isn't the latest version!)
Once that's done, type the following in the Terminal to start Julia and install the PiGPIO package we'll be using today to play around with the LEDs!

```julia
julia
]add PiGPIO
```

Once that's done, click on the **delete button** once to leave the Pkg mode. 
Then, type the following to exit julia.

```julia
exit()
```

Finally, type the following to give you admin permission to let you control GPIO.

```
sudo pigpiod
```

Then, you're all set for Chapter 2!

## Chapter 2: A Single Circuit

### Step 1: Gathering the equipment

Congrats on getting your Raspberry Pi set up! For a single circuit, you will need the following equipment in addition to the Raspberry Pi:
- 1 LED
- 1 330Ω Resistor
- 1 Breadboard
- 2 Male to Female Jumper cables

For this experiment, it’s important that you have a resistor with a resistance of around 330Ω as we need to limit the amount of current passing through the circuit. We definitely don’t want a huge current breaking our circuit and equipment, do we?!

### Step 2: Connecting the circuit

Now if you look carefully at a LED, you will probably notice that it has 2 legs, with one being longer than the other. Well, the longer leg, which is called the “anode”, is positive, and will thus be connected to the positive supply, and the shorter leg is called the “cathode”, which will be connected to ground.

For this circuit, let’s have the positive towards the top of the breadboard and negative towards the bottom. Now you can insert your LED in a way such that the legs are on different rows with the longer (positive) leg being on a row above the shorter leg.

![2](https://user-images.githubusercontent.com/28962234/72093562-89a2e680-330c-11ea-968c-e5b27deefb70.jpeg)

Now, put a resistor at a position where one of its legs is on the same row as the top leg of the LED and its other leg on any row you like that’s above the previous row. Once that’s done, insert both jumper cables (male side) in any holes that’s on the same row as the top leg of the resistor and the bottom leg of the LED.

![3](https://user-images.githubusercontent.com/28962234/72093578-8e679a80-330c-11ea-8866-d832c71b49bc.jpeg)

Now, you may be wondering where we place the other end of the jumper cables? <br/>
(The following image is from [raspberrypi.org](https://www.raspberrypi.org/documentation/usage/gpio/) and is licensed under [CC BY-SA](https://www.raspberrypi.org/creative-commons/).)

![4](https://user-images.githubusercontent.com/28962234/72093579-8e679a80-330c-11ea-8371-fb64976061fc.png)

As you can see here from the image above, there are a lot of PGIO ports. But don’t worry - I’ve got you. At the moment, your top jumper cable should be the positive one, and your bottom one being the group one. Place your top one at any ports where it has “GPIO” on. Here, I will be using port 7 for demonstration (which has the GPIO number 4). As for the bottom cable, place it anywhere you like where it says “Ground”. Today, I’ll be using port 6 for that.

![5](https://user-images.githubusercontent.com/28962234/72093580-8e679a80-330c-11ea-8c7a-6d953c0997c5.jpeg)

Now that you have all the components set up, you may now move onto part 3!

### Step 3: Running the script

Now, open File Manager and go to the folder where you would like to store your file for this. Then, right click and select the option `Create New...` and then `Empty File`. Name it `led1.jl` and click `OK` when you're done.

Then, double click the file to open it and paste the following code into it.
```julia
using PiGPIO

pin = 4 #change this accordingly with your GPIO number
p=Pi()
set_mode(p, pin, PiGPIO.OUTPUT) #changed to OUTPUT mode so that we can control it
try 
    for i in 1:10 #how many times the loop is going to run
        PiGPIO.write(p, pin, PiGPIO.ON)
        sleep(0.5) #how long the LED is on each time
        PiGPIO.write(p, pin, PiGPIO.OFF)
        sleep(0.5) #how long the LED is off each time
    end
finally
    println("Cleaning up!")
    set_mode(p, pin, PiGPIO.INPUT) #changed it back to INPUT mode
end
```

Do remember to change the GPIO number with the one you chose! Click `Save` when you're done and now you can go back to Terminal and type the following.

```
julia <path to your file>/led1.jl
```
eg. ```julia /home/pi/Documents/led1.jl```

Hopefully you should get the following result!

![6](https://user-images.githubusercontent.com/28962234/72093581-8e679a80-330c-11ea-8890-5d408dcd65c2.jpeg)

You can now go back to your code and change the number of times you want to loop to run or the time it's on/off for each time, or, if you're feeling brave, move straight onto Chapter 3!

## Chapter 3: Getting 2 Circuits

Congrats for getting the circuit running! Now, let’s make it a little bit more complicated, with the end goal of having 2 LEDs light up alternatively.

### Step 1: Gathering the equipment (once again!)

This time, you will need the following equipment: 
- Everything from Chapter 2 plus...
- 1 extra LED (hopefully with a different color! I’ll be using blue today)
- 1 extra 330Ω Resistor
- 2 extra Male to Female Jumper cables

### Step 2: Connecting the circuit

Follow the same instructions for Chapter 1, except you place the LED, resistor, and jumper cables at completely different positions, while keeping the same setup you did for Chapter 2. Do remember to note down your GPIO number as it will be used later when we are writing the script! 

This is what your breadboard should look like by now!

![7](https://user-images.githubusercontent.com/28962234/72093582-8e679a80-330c-11ea-8c58-07b4f310d17e.jpeg)

### Step 3: Running the script

Once you're confident, you can now start running the script. The script itself is quite similar to the last one, with just a few additions. Don't worry!

First, open File Manager and go to the folder where you would like to store your file for this. Then, right click and select the option `Create New...` and then `Empty File`. Name it `led2.jl` and click `OK` when you're done.

Then, double click the file to open it and paste the following code into it.

```julia
using PiGPIO

pin1 = 4 #change these numbers accordingly with your GPIO numbers
pin2 = 17

p=Pi()

set_mode(p, pin1, PiGPIO.OUTPUT)
set_mode(p, pin2, PiGPIO.OUTPUT)

try 
    for i in 1:10 #how many times the loop is going to run
        PiGPIO.write(p, pin1, PiGPIO.ON)
        PiGPIO.write(p, pin2, PiGPIO.OFF)
        sleep(0.5) #the time pin1 is on and pin2 is off
        PiGPIO.write(p, pin1, PiGPIO.ON)
        PiGPIO.write(p, pin2, PiGPIO.OFF)
        sleep(0.5) #the time pin1 is off and pin2 is on
    end
finally
    println("Cleaning up!")
    set_mode(p, pin1, PiGPIO.INPUT)
    set_mode(p, pin2, PiGPIO.INPUT)
end
```

Do remember to change the GPIO number with the one you chose! Click `Save` when you're done and now you can go back to Terminal and type the following.

```
julia <path to your file>/led2.jl
```
eg. ```julia /home/pi/Documents/led2.jl```

Hopefully you should get the following result! (My image isn't a gif so it won't show them blinking alternatively, but you get what I mean!)

![8](https://user-images.githubusercontent.com/28962234/72093584-8e679a80-330c-11ea-8e69-e1f9bdc7c020.jpeg)

You can now go back to your code and change the number of times you want to loop to run or the time it's on/off for each time, just like you did for Chapter 2.
Once again, congrats for getting your LEDs blinking and thanks for reading!

### written by kfung

References: <br/>
https://www.raspberrypi.org/documentation/usage/gpio/ <br/>
https://www.instructables.com/id/Control-LED-Using-Raspberry-Pi-GPIO/ <br/>
https://github.com/JuliaBerry/PiGPIO.jl
