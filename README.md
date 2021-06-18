WebCraft (HTML5 Minecraft)
---------------------
[![GitHub issues]](https://github.com/ZombieBrine13092/WebCraft/issues)
[![GitHub forks]](https://github.com/ZombieBrine13092/WebCraft/network)
[![GitHub stars]](https://github.com/ZombieBrine13092/WebCraft/stargazers)
[![GitHub license]](https://github.com/ZombieBrine13092/WebCraft/blob/master/LICENSE)

This project is intended to become a Minecraft Classic clone using HTML 5 technologies, most notably WebGL and WebSockets. No third-party libraries are used, with the exception of glmatrix and socket.io. People who have written similar demos used libraries such as *three.js*, but it is
both foolish and inefficient to use a 3D engine for rendering large amount of blocks.

Running the client and server
---------------------

The client and server both require NodeJS and NPM to function. You can get it at https://nodejs.org.
After installing Node and NPM, run InstallDependencies.bat in the release folder to install all required modules.

*Running the client*:
Start the script **RunGame.bat.**

*Running the server*:
Open a command prompt in the release folder and run '**node server.js**' (without quotes.)

The client server runs on port 8080, and the server's IP is http://<device ip>:3000/multiplayer.html.
The server window acts as an HTTP server on port 3000, and it connects you to the game server when you order multiplayer.html.


Screenshots
---------------------

<a href="http://i.imgur.com/tDzki.png">![Singleplayer structure](http://i.imgur.com/2qBGy.png)</a>

Structure
---------------------

+ *data/* - Contains all data in the project other than singleplayer.html, multiplayer.html, and server.js.
+ *singleplayer.html* - The front-end for the singleplayer client.
+ *multiplayer.html* - The front-end for the multiplayer client.
+ *server.js* - The Node.js server code.

Modules
---------------------

The two front-ends invoke the available modules to deliver the components necessary for the gameplay and graphics of either the singleplayer or multiplayer experience. The available modules are listed below.

**Blocks.js**

This is the most *moddable* module, as it contains the structure with the available block materials and their respective properties. It also contains functions invoked by the render class for proper shading and lighting of blocks.

**World.js**

This is the base class, which all other modules depend on. Although it is a very important module, it is also the most passive module. It contains the block structure of the world and exposes functions for manipulating it.

**Physics.js**

This module has strong roots in the world class and simulates the flow of fluid blocks and the gravity of falling blocks at regular intervals. It has no specific parameters and is simply invoked in the game loop to update the world.

**Render.js**

This is the module that takes care of visualizing the block structure in the world class. When a world is assigned to it, it sets up a structure of chunks that are updated when a block changes. These chunks are mostly just fancy Vertex Buffer Objects. As this module takes care of the rendering, it also houses the code that deals with *picking* (getting a block from an x, y position on the screen).

**Player.js**

Finally there is also the module that handles everything related to the player of the game. Surprising, perhaps, is that it also deals with the physics and collision of the player. Less surprising is that it manages the material selector and input and responds to it in an update function, just like the physics module.

**Network.js**

This module makes it easy to synchronize a world between a server and connected clients. It comes with both a *Client* and *Server* class to facilitate all of your networking needs.

Typical game set-up
---------------------

First a new world is created and the block structure is initialised.

	var world = new World( 30, 30, 30 );
	world.createFlatWorld( 6 );

The *6* in *createFlatWorld* here is the line between the ground and the first air layer.

Now that we have a world, we can set up a renderer, which will subsequently divide the world into chunks for rendering.

	var render = new Renderer( "renderSurface" );
	render.setWorld( world, 8 );
	render.setPerspective( 60, 0.01, 200 );

The *8* here determines the XYZ size of one chunk. In this case the entire world consists out of 8 chunks.

To finish the code that deals with world management, we create the physics simulator.

	var physics = new Physics();
	physics.setWorld( world );

And finally, we add a local player to the game:

	var player = new Player();
	player.setWorld( world );
	player.setInputCanvas( "renderSurface" );
	player.setMaterialSelector( "materialSelector" );

That concludes the set-up code. The render loop can be constructed with a timer on a fixed framerate:

	setInterval( function()
	{
		var time = new Date().getTime() / 1000.0;
		
		// Simulate physics
		physics.simulate();
		
		// Update local player
		player.update();
		
		// Build a chunk
		render.buildChunks( 5 );
		
		// Draw world
		render.setCamera( player.getEyePos().toArray(), player.angles );
		render.draw();
		
		while ( new Date().getTime() / 1000 - time < 0.016 );
	}, 1 );

To see how the material selector and canvas can be set-up, have a look at *singleplayer.html* and *style/main.css*. Note that the player and physics modules are entirely optional, so you could just as well use this code as a base for making a Minecraft map viewer on your website.
