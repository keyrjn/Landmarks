{DeviceOrientationManager} = require "DeviceOrientationManager"
orientationManager = new DeviceOrientationManager
Screen.backgroundColor = "28affa"

{ mapboxgl } = require "npm"

#mapSetup
mapLayer = new Layer
	height: Screen.height
	width: Screen.width
	parent:nullLayer

mapLayer.html = "<div id='map'></div>"
mapLayer.ignoreEvents = false
mapElement = mapLayer.querySelector("#map")
mapElement.style.height = Screen.height + 'px'

# Set your Mapbox access token here
mapboxgl.accessToken = 'pk.eyJ1Ijoia2V5dXJqYWluMjEiLCJhIjoiY2lpamk4eWl5MDEycXVka242bTB5aXk5MCJ9.YwZqFTtsJKymb8vAENy3wA'


map = new mapboxgl.Map
	container: mapElement
	zoom: 13
	center: [12.579,55.679]
	style: 'mapbox://styles/keyurjain21/cj9n6g9zf36wv2slnar5m3vxd'
	
coordinates = {latitude : 55.679, longitude : 12.579}
success = (p) ->
	coordinates.latitude = p.coords.latitude
	coordinates.longitude = p.coords.longitude
# 	print coordinates
	locationCircle.backgroundColor="green"
	return

error = (msg) ->
#   print "error"
  locationCircle.backgroundColor="red"
  return

#List of coordinates
targetCoordinatesGL = [
	{latitude : 55.680, longitude : 12.587},
	{latitude : 55.672, longitude : 12.523},
	{latitude : 55.674, longitude : 12.569},
	{latitude : 55.692, longitude : 12.599},
	{latitude : 55.674, longitude : 12.598}
	]

#Get the device location + Fly to  
locationCircle.onTap (event, layer) ->
	navigator.geolocation.getCurrentPosition(success, error)
	Utils.delay 1, ->
		map.flyTo({center: [coordinates.longitude, coordinates.latitude]});

# 	print distance(coordinates, targetCoordinatesGL[0])
# 	print "Osterbro:" + heading(sourceCoordinates, targetCoordinates[0])



#distance
distance = (originCoordinates, destinationCoordinates) ->
	degToRad = Math.PI / 180
	lat1 = originCoordinates.latitude
	lon1 = originCoordinates.longitude
	
	lat2 = destinationCoordinates.latitude
	lon2 = destinationCoordinates.longitude
	
	R = 6371000 # metres
	
	φ1 = lat1 * degToRad
	φ2 = lat2 * degToRad
	Δφ = (lat2-lat1) * degToRad
	Δλ = (lon2-lon1) * degToRad
	a = Math.sin(Δφ/2) * Math.sin(Δφ/2) + Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ/2) * Math.sin(Δλ/2)
	c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))
	d = R * c
	return d

# heading
heading = (originCoordinates, destinationCoordinates) ->
	degToRad = Math.PI / 180

	lat1 = originCoordinates.latitude * degToRad
	lon1 = originCoordinates.longitude * degToRad
	lat2 = destinationCoordinates.latitude * degToRad
	lon2 = destinationCoordinates.longitude * degToRad

	angle = Math.atan2(Math.sin(lon2 - lon1) * Math.cos(lat2), Math.cos(lat1) * Math.sin(lat2) - Math.sin(lat1) * Math.cos(lat2) * Math.cos(lon2 - lon1))
	headingAngle = angle * 180 / Math.PI
	headingAngle += 360 if headingAngle < 0
	return headingAngle


{DeviceOrientationManager} = require "DeviceOrientationManager"
orientationManager = new DeviceOrientationManager
Screen.backgroundColor = "white"

rotationNormalizer = Utils.rotationNormalizer()

orientationManager.onOrientationChange (data) ->
	compassHeading = data.compassHeading
	compassHeading *= -1 if data.elevation < 0
	NorthAngle = rotationNormalizer(compassHeading)


Palette = ["orange","green","blue","purple","red"]
TargetNames = ["Nyhavn Boats","København Zoo","Tivoli","Little Mermaid","Christiania Church"]

disks = []
for i in [0..4]
	disk = new Layer
		width:330
		height:330
		backgroundColor:"rgba(2, 2, 2, 0.005)"
		borderRadius: 200
		borderWidth: 0
		x: Align.center
		y: Align.center
		opacity:0
	disks.push(disk)

pointers = []
for i in [0..4]
	pointer = new Layer
		parent:disks[i]
		width:16
		height:16
		borderWidth: 3
		borderColor:Palette[i]
		backgroundColor: "white"
		borderRadius: 15
		x: Align.center
		y: Align.center
	pointers.push(pointer)


legends = []
for i in [0..4]
	legend = new Layer
		width:Screen.width / 5 - 1
		height:9
		backgroundColor: "null"
		x: ((Screen.width / 5 - 1)*i)
		y: 40
		opacity: 0
		Align: Align.center
	legends.push(legend)


legendsColor = []
for i in [0..4]
	legendColor = new Layer
		parent:legends[i]
		width:11
		height:11
		borderWidth: 3
		borderColor: "grey"
		backgroundColor: "white"
		borderRadius: 15
		y: Align.center()
		x: Align.center()
	legendsColor.push(legendColor)


legendstext=[]
for i in [0..4]
	legendtext = new TextLayer
		parent:legends[i]
		width: Screen.width / 5 - 1
		backgroundColor: "null"
		y:17
# 		x:((Screen.width / 5 - 1)*i)
		fontSize: 11
		text: TargetNames[i]
		color: "grey"
		padding: 
			left:10
			right:10
		textAlign: Align.center
	legendstext.push(legendtext)





#Setup GUI
targetPrompt = new TextLayer
		parent:targetPromptBox
		x:Align.center
		fontFamily: "Avenir"
		fontSize: 28
		fontWeight: 500
		text: ""
		textAlign: "center"

Prompt = new TextLayer
		parent:PromptBox
		x:Align.center
		fontFamily: "Avenir"
		fontSize: 12
		fontWeight: 300
		text: ""
		textAlign: "center"



oval.states.a =
	scale: 7.00
	
oval.states.b =
	scale: 1

counter = 0



button2.onTapStart ->
	oval.animate("b")

	counter = (counter+1) % 5
	for i in [0..4]
# 		pointers[i].opacity=0
		disks[i].opacity=0

		legendsColor[i].borderColor="grey"
		legendsColor[i].backgroundColor="grey"
		legendsColor[i].backgroundColor="grey"

	targetPrompt.text = TargetNames[counter]
	targetPrompt.color = Palette[counter]
	targetPrompt.textAlign= "center"
	targetPrompt.x= Align.center

	if counter != 0
		for i in [0..counter-1]
			pointers[i].opacity=1

	for i in [0..counter]
		legendsColor[i].borderColor=Palette[i]
		legendsColor[i].backgroundColor="white"

	Prompt.text = "Point at"
	Prompt.textAlign= "center"
	Prompt.x= Align.center
# 	if counter == 0
# 		for i in [0..4]
# 			pointers[i].opacity=0

	button.onLongPressStart (event, layer) ->
		for i in [0..counter]

			legends[i].animate
				properties:
					opacity:1

			disks[i].animate
				properties:
					opacity:1

	button.onLongPressEnd (event, layer) ->
		for i in [0..counter]
			legends[i].animate
				properties:
					opacity:0
			disks[i].animate
				properties:
					opacity:0
		button.enabled = false




counter2 = 0
button2.onTapEnd ->
	oval.animate("a")

	counter2 = (counter2+1) % 5
	disks[counter2].animate
		properties:
			opacity:1
# 	console.log(disks[counter2])

# 	if counter2 != 0
# 		for i in [0..counter2-1]


	button2.html= counter2
	button2.color = "black"
	button.html="peek"

	targetPrompt.text = "Not Bad"
	targetPrompt.color = Palette[counter]
	targetPrompt.textAlign= "center"
	targetPrompt.x= Align.center

	Prompt.text = 

	Utils.delay 2,->
		Prompt.text = "Tap & Hold for Next "
		Prompt.textAlign= "center"
		Prompt.x= Align.center


	LandmarkDistance =distance(coordinates, targetCoordinatesGL[counter])



	if LandmarkDistance< 1000
		pointers[counter].y=95

	else if LandmarkDistance< 2000 & LandmarkDistance>1000
		pointers[counter].y=45

	else if LandmarkDistance> 2000
		pointers[counter].y=-5
	



#Rotating objects
rotationNormalizer = Utils.rotationNormalizer()

orientationManager.onOrientationChange (data) ->
	compassHeading = data.compassHeading
	compassHeading *= -1 if data.elevation < 0
	NorthAngle = rotationNormalizer(compassHeading)
	sourceCoordinates = coordinates

	#List of coordinates
	targetCoordinates = targetCoordinatesGL

	angles=[]
	for i in [0..4]
		angle=NorthAngle-(360-Math.abs(heading(sourceCoordinates, targetCoordinates[i])))
		angles.push(angle)

	for i in [0..4]
		disks[i].animate
			properties: rotation: angles[i]
			time: 0.3

	r=Math.floor(data.compassHeading)
	if r<=180
		b = -r
	else b=360-r

	compass.animate
		properties: rotation: NorthAngle
		time: 0.3

