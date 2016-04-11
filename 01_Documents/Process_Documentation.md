# Process Documentation
## Creating base GIS layers
### Creating the corner shapefile
* Select Lion streets for Manhattan (Lion shapefiles can be found [here](http://www.nyc.gov/html/dcp/html/bytes/dwnlion.shtml))
  * Clean the Lion file by selecting only the actual streets (use the FeatureTyp field to select only type `0`)
* Select PLUTO lots for Manhattan (PLUTO dataset can be found [here](http://www.nyc.gov/html/dcp/html/bytes/dwn_pluto_mappluto.shtml))
* To obtain the corner points do the following:
  * Use the `Dissolve` tool to merge small street segments (don't create `multipart features` or `unsplit lines`)
  * Use the `Feature Vertices to Point` tool (with the `Both Ends` option) to create points at the end of each new segment
  * Use the `Collect Events` tool to eliminate duplicate points on the intersections
  * Finally, use the `Integrate` tool, with a tolerance of 35ft to gather the corners that would be too close (for example, the different lanes in Park Avenue)

### Adding the PLUTO data to the corner shapefile
* Use the `Feature to Point` tool to convert the PLUTO polygons to points (use the option `Inside` to make sure the new point falls inside the original polygon)
* In ArcCatalog build the Network Analysis layer based on the Lion street file:
  * First create a `Personal Geodatabase`
  * In this database, create a new `Feature Dataset`
  * Into this feature dataset, `Import` the Lion street file
  * If necessary, add a field to this new street file called `Minutes` and make it of type `Double`
  * In this feature dataset create a new `Network Dataset` and use the new streets file as a participant (do NOT build the network yet)
* Back in ArcMap add the new network to the map and build it:
  * Calculate the `Minutes` field by doing `ShapeLength / 308` (308 is ft/min, based on an average walking speed of 3.5 miles per hour)
  * After you have calculated this field, build the network
* Create a `New OD Cost Matrix`:
  * Add the PLUTO points as `Origins` (don't `Snap to Network`) (given the number of PLUTO lots, this process might take a while)
  * Add the Lion_Street_Points_Collected as `Destinations`
  * After this is setup, make sure to change the `Analysis Settings` for the `Default Cutoff Value` to the desired maximum minutes and the `Destinations to Find` to 1, to make sure you only find the distance to the closest and not to all.
  * Solve the network
  * Export your OD Lines to a new layer
* After that, join the PLUTO points to the OD_Lines, so that the lines get the attributes of the PLUTO lots:
  * Make sure you use a `Spatial Join` based on location and that you select `Intersect` and then you choose one way of summarizing the attributes. In this case I chose `Maximum` but I don't think it matters that much, since we are supposed to be joining 1 to 1. If by any very weird chance, there are lines that intersect with multiple points, then the maximum would be preferable than `Sum`. Again, this is a very slight chance but it's difficult to prevent this from happening.
* And again, `Join by Location` the lines with all the new information to the corner points:
  * Here, though, make sure you use `Sum` because we need to aggregate all the data for multiple buildings into the corners.
* Finally, you need to clean the data:
  * Delete unecessary columns and rename the important columns

### Adding the Census data to the corner shapefile
* As a dataset we used the 2014 ACS 5-year estimates.
* Select the right geographic area (Census Block Groups for New York County, NY) and download the following tables from [American Factfinder](http://factfinder.census.gov/faces/nav/jsf/pages/index.xhtml):
  * B01002 - Median Age by Sex
  * B19013 - Median Household Income
  * B15003 - Educational Attainment
  * B01003 - Total Population
  * B08301 - Means of Transportation to Work
* Downloaded the census block group shapefiles from the US Census Bureau [ftp site](ftp://ftp2.census.gov/geo/tiger/TIGER2014/BG/) which provides higher resolution files than the simple [website](https://www.census.gov/geo/maps-data/data/cbf/cbf_blkgrp.html).
* Join the tables to the shapefile
* Calculate census block group area fields (square feet and square miles) and population density (total people / square mile)
* Create a 25ft buffer around the corners so that they can absorb the values of adjacent block groups
* Spatial join the buffer to the census block groups using the `Average` option
* Spatial join the buffer to the corner points (with the PLUTO data)

### Final fields
* LotCount - Number of PLUTO lots
* SumLotArea - Sum of area of PLUTO lots (sq ft)
* SumBldgAre - Sum of building area from PLUTO lots (sq ft)
* SumComArea - Sum of commercial area (sq ft)
* SumResArea - Sum of residential area (sq ft)
* SumOffArea - Sum of office area (sq ft)
* SumRetArea - Sum of retail area (sq ft)
* SumGargAre - Sum of garage area (sq ft)
* SumStrgAre - Sum of storage area (sq ft)
* SumFactAre - Sum of factory area (sq ft)
* SumOtherAr - Sum of other area (sq ft)
* SumNumBldg - Sum of number of buildings
* SumNumFloo - Sum of number of floors
* ResUnits - Sum of residential units
* TotalUnits - Sum of total units
* AssessLand - Sum of assessed value of land from PLUTO
* AssesTotal - Sum of total assessed value
* ExemptLand - Sum of exempt value of land
* ExemptTota - Sum of total exempt value
* SumShpArea - Sum of shape areas from PLUTO lots (sq ft)
* Avg_MedAge - Average median age
* Avg_MaleMd - Average of median age for males
* Avg_FemMdA - Average of median age for females
* Avg_TotalP - Average of total population
* Avg_Pop25 - Average of population over 25 years
* Avg_HsOrLe - Average of percentage of population with high school or less
* Avg_SomeCl - Average of percentage of population with some college education
* Avg_Colleg - Average of percentage of population with college degree
* Avg_MoreCl - Average of percentage of population with more than college (Masters or PhD)
* Avg_MdHhIn - Average median household income
* Avg_WorkPo - Average population over 16
* Avg_Car - Average of percentage of population commuting by car (including carpool)
* Avg_PblcTr - Average of percentage of population commuting by public trasnportation
* Avg_Taxica - Average of percentage of population commuting by taxicabs
* Avg_Moto - Average of percentage of population commuting by motorcycle
* Avg_Bicycl - Average of percentage of population commuting by bicycle
* Avg_Walk - Average of percentage of population commuting by walking
* Avg_OtherT - Average of percentage of population commuting by other means
* Avg_WrkHom - Average of percentage of population working from home
* AvgAreaSF - Average area of census block group (sq ft)
* AvgAreaSM - Average area of census block group (sq mi)
* Avg_PopSm - Average of population per square mile
* lat - Latitude of the corner
* lon - Longitude of the corner

### Problems with this method
* *One of the problems this process has is that every lot is only assigned to one corner. While this might be ok for most lots, for the large ones, the ones that are "through lots" or the ones that take up a whole block, this doesn't make total sense. Intuitively, I think that the influence of these lots should be spread over multiple corners. These large lots usually have multiple entrances and so people from these lots go to different corners to take a cab. An extreme example of this would be Central Park: what corner should we assign Central Park's values to?*

## Selecting Taxi Trips
This 'chapter' details the steps to select taxi trips that fall inside the selected area. The base taxi trips are the ones from 2013 that have a medallion and license number (hashed). The source for this data is [here](http://www.andresmh.com/nyctaxitrips/), courtesy of Chris Wong and Andres Monroy.
### Creating a bounding box for the selected streets
* In qGIS got to `Vector` `Geoprocessing Tools` `Buffer(s)`.
* The inputs are the following:
  * Input vector layer: 'Streets_Selected_Midtown'
  * Buffer distance: '300' (this will be in feet)
  * Dissolve buffer results: checked

### Creating database and adding layers
* First, start the database cluster. See [here](https://github.com/juanfrans/notes/wiki/Creating-a-Spatial-Database-(PostGIS))
* Create a new database: `createdb TaxiPredictions`
* Enter database: `psql TaxiPredictions`
* Enable the postgis extension with `CREATE EXTENSION postgis;`
* Add the 'Streets_Selected_Buffer_300ft.shp' file to the database:
  * `shp2pgsql -s 2263 ../01_Shapefiles/01_Process_Shapefiles/Streets_Selected_Buffer_300ft.shp | psql -d TaxiPredictions`
* In the database, create the table where the taxi trips are going to be added:
```sql
CREATE TABLE Yellow_Origins_1301 (
gid serial NOT NULL,
medallion text,
hack_license text,
vendor_id text,
rate_code int,
store_and_fwd_flag text,
pickup_datetime timestamp,
dropoff_datetime timestamp,
passenger_count int,
trip_time_in_secs int,
trip_distance float,
pickup_longitude float,
pickup_latitude float,
dropoff_longitude float,
dropoff_latitude float,
the_geom geometry,
CONSTRAINT yellowOrigins1301_pkey PRIMARY KEY (gid),
CONSTRAINT enforce_dims_the_geom CHECK (st_ndims(the_geom) = 2),
CONSTRAINT enforce_geotype_geom CHECK (geometrytype(the_geom) = 'POINT'::text OR the_geom IS NULL),
CONSTRAINT enforce_srid_the_geom CHECK (st_srid(the_geom) = 4326)
);
```
* Then create index:
```sql
CREATE INDEX yelloworigins1301_the_geom_gist
ON Yellow_Origins_1301
USING gist
(the_geom );
```
* Then actually copy the file to the table:
  *  `\copy yellow_origins_1301(medallion,hack_license,vendor_id,rate_code,store_and_fwd_flag,pickup_datetime,dropoff_datetime,passenger_count,trip_time_in_secs,trip_distance,pickup_longitude,pickup_latitude,dropoff_longitude,dropoff_latitude) FROM 'path/to/folder/trip_data_1.csv' DELIMITERS ',' CSV HEADER;`
  * And we can test it by calling any of the columns: `select pickup_longitude from yellow_origins_1301;`
* Finally, create the actual geometry for the table based on the pickup longitude and latitude:
```sql
UPDATE yellow_origins_1301
SET the_geom = ST_GeomFromText('POINT(' || pickup_longitude || ' ' || pickup_latitude || ')',4326);
```
* To be able to do the spatial queries, however, both layers have to be in the same projection. To change the projection of the taxi trip layer do:
  * You can check the projection with: `select st_srid(the_geom) from yellow_origins_1301 limit 1;`
  * Removing a constraint so you can reproject:
  `alter table yellow_origins_1301`
  `drop constraint "enforce_srid_the_geom";`
  * Now, to actually alter the table (reproject it) we need first to delete some problematic records (ie. those with longitudes exceeding limits).
  * Test for those records by: `select count(t.pickup_latitude) from yellow_origins_1301 as t where t.pickup_latitude > 90;` or print the actual latitude by: `select pickup_latitude from yellow_origins_1301 where pickup_latitude > 90`
  * Finally, you can delete these records by: `delete from only yellow_origins_1301 where pickup_latitude > 90 returning *;`
  * You need to check also for negative latitude and positive or negative longitude problems.
  * And the actual re-projection is here:
  ```sql
  alter table yellow_origins_1301
  alter column the_geom type geometry(point,2263)
  using st_transform(the_geom,2263);
  ```
  * To test it do: `select count(t.pickup_latitude) from yellow_origins_1301 as t, streets_selected_buffer_300ft as n where st_intersects(t.the_geom,n.geom);`
  
  * Add layer based on destinations

### Querying database and exporting results
  * Select the records that end in our zone and look at those taxis and where they picked up their following passenger
  * Select the records that start in our zone and look at where they came from and where they are going to
    * Create a table with the trips that ended in our zone:
    ```sql
    create table temp_results as
    select medallion, hack_license, dropoff_datetime, dropoff_latitude, dropoff_longitude from yellow_dest_1301 as t, streets_selected_buffer_300ft as n where st_intersects(t.the_geom,n.geom);
    ```
    * Export results to new csv file: `copy temp_results to '/path/to/file/01_SelectedTrips_1301.csv' delimiter ',' csv header;`

### Final filtering of results

## Creating API with model
This 'chapter' describes the process of setting up an API - using Amazon Web Services - with the current model to create a [Processing](processing.org) visualization. This process is based on these tutorials and sites:
* http://blog.miguelgrinberg.com/post/designing-a-restful-api-with-python-and-flask
* http://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world
* http://www.fullstackpython.com/api-creation.html
* https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-flask.html
* http://flask.pocoo.org/docs/0.10/installation/
* https://processing.org/discourse/beta/num_1265814661.html

### Initial setup
* Root url access: `http://[hostname]/predictive/api/v1.0/`
* Method: GET -> `http://[hostname]/predictive/api/v1.0/predict` -> predict taxi pickups for a specific location
* Method: GET -> `http://[hostname]/predictive/api/v1.0/predict_array` -> predict taxi pickups for an array of locations (these two should be merged into one in the future)
* Install virutal environment: `sudo pip install virtualenv`
* Create the virtual environment: `virtualenv venv`
* Activate the virtual environment: `. venv/bin/activate`
* Install flask in the virtual environment: `pip install flask`
* Create flask folder: `virtualenv flask`
* When returning do:
  * `. venv/bin/activate` to activate the virtual environment
  * run the python script that contains the flask code
* To leave virtualenv do `deactivate`


#### AWS (Don't know if I need it yet)
* In AWS:
  * Setup new instance
  * Public DNS: ec2-54-173-95-186.compute-1.amazonaws.com
  * Setup all users and permissions following this [document](https://github.com/juanfrans/notes/wiki/Setting-Up-and-Login-In-to-an-EC2-Instance-(AWS)).
  * Customize instance following [this](https://github.com/juanfrans/notes/wiki/Customizing-EC2-Instance-(AWS)).

## Creating postGIS online for querying
I'm looking at the following blogs and sites for documentation:
* [AWS](https://aws.amazon.com/rds/postgresql/)
* [AWS postGIS setup](http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.PostGIS)
* [Boundless](http://boundlessgeo.com/2013/12/postgis-amazon-rds/)
* [Pheelicks](http://www.pheelicks.com/2014/01/creating-a-geospatial-database-on-amazon-rds/)

### Launching the RDS instance
* Log into AWS.
* Go to the RDS tab.
* Click `Get Started`.
* Choose PostgreSQL.
* Choose Dev/Test to use the Free Usage Tier.
* In the DB Details choose the following:
  * DB Engine: postgres
  * License Model: postgresql-license
  * DB Engine Version: 9.4.7 (I don't know why this one is better or if it is. There's a newer one but this was the default).
  * DB Instance Class: db.t2.micro (Don't know which one to choose here, I'm choosing the one with the largest RAM).
  * Storage Type: General Purpose
  * DB Instance Identifier: predictivedb
* In the Advanced Settings:
  * Download the new certificate bundle (?)
  * Make sure it's publicly accessible
  * VCP Security Group(s): Create new security group
  * Database Name: taxiPredictive
  * Database Port: 5432
* Click on `Launch DB Instance`

### Setting up the security group
* Go to the EC2 Console (Network & Security) to configure the security group you just created.
* Edit the inbound rules and change the source to `Anywhere`.
* Save the rule.

### Connecting to the DB
* Get the location of your DB by going to Services/RDS/Instances and expanding your instance.
* To connect do the following in command line:
  * `psql --host predictivedb.cqstqsnchb9m.us-east-1.rds.amazonaws.com --port 5432 --username your_username --dbname taxiPredictive`
  * Type the password when requested.

### Create the postGIS extension
* Following [this part](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.PostgreSQL.CommonDBATasks.html#Appendix.PostgreSQL.CommonDBATasks.PostGIS) of the AWS documentation.
* Log into the database with your 'master' user, the one that was created when you first setup your database.
* You can test it with the following command: `SELECT current_user;`.
* Create the extension: `create extension postgis;`
* Create the fuzzystrmatch extension: `create extension fuzzystrmatch;`
* Create the tiger_geocoder extension: `create extension postgis_tiger_geocoder;` (this is a geocoder extension that works with the Tiger dataset)
* Create the topology extension: `create extension postgis_topology;`
* To see the ownership of the extensions do: `\dn`
* Transfer ownership of the extensions to the superuser:
  * `alter schema topology owner to rds_superuser;`
  * `alter schema tiger owner to rds_superuser;`
  * `alter schema tiger_data owner to rds_superuser;`
* Transfer ownership of the objects to the rds_superuser role:
```sql
CREATE FUNCTION exec(text) returns text language plpgsql volatile AS $f$ BEGIN EXECUTE $1; RETURN $1; END; $f$;
SELECT exec('ALTER TABLE ' || quote_ident(s.nspname) || '.' || quote_ident(s.relname) || ' OWNER TO rds_superuser;')
  FROM (
    SELECT nspname, relname
    FROM pg_class c JOIN pg_namespace n ON (c.relnamespace = n.oid) 
    WHERE nspname in ('tiger','topology') AND
    relkind IN ('r','S','v') ORDER BY relkind = 'S')
s;
```
* Test the extensions:
  * Tiger:
    * `SET search_path=public,tiger;`
    * `select na.address, na.streetname, na.streettypeabbrev, na.zip`
    * `from normalize_address('1 Devonshire Place, Boston, MA 02109') as na;`
  * Topology:
    * `select topology.createtopology('my_new_topo',26986,0.5);`

### Create other users
To create other users login to the database as a superuser and do: `create role roleName with password 'password' login;`

### Querying the postGIS RDB in AWS
* The basic sql query will look like this: `select dropoff_longitude, dropoff_latitude from yelloworg130116 where ST_Distance_Sphere(the_geom, ST_MakePoint(longitude, latitude)) < distance;` (the distance will be in meters).
* Can [this](https://stackoverflow.com/questions/5297396/quick-random-row-selection-in-postgres) be the solution to select a random result?
* And maybe [this](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Using_the_Query_API.html) is the solution to querying the database through an HTTP request?

### To do:
* Setup another user for Danil
* Load taxi data for one day
* Try out queries
* Is there a way to pre-build queries so that you only have to pass a pair of coordinates and a request and get the data?






















