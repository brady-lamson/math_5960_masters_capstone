=== Iowa Spatial Structure <iowa_spatial>

Iowa was chosen for this project for a few reasons. The first is that it has some very populated counties and very sparsely populated counties. This allows for a good demonstration of the Fay-Herriot model as it can effectively pool from informative counties. This will be discussed in more detail in later sections. 

Second is the layout of its counties. Iowa has 99 counties total and they are arranged in a very neat grid as shown in the figure below. On average, each county has $5.9$ neighbors with a minimum of 3 and a maximum of 8. There are no disjointed islands or bizarre geometries that would complicate spatial calculations as well. As such, this state shows useful properties for both Fay-Herriot modeling and spatial methods. 

#figure(
  image("../../../../images/iowa_neighborhood_links.png", width: 80%),
  caption: "Plot showing adjacent county links across Iowa."
)