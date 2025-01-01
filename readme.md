# Run multiple jars and tomcat in the same dockerfile
#### Have separed services isnt always the best solution, so here is a strategy to slowly migrating services, by starting, like from linux pure services to 1 dockerfile solution  


<br/>

## SupervisorD
### application for building services just with a text config file

Documentation:
https://supervisord.org/introduction.html


## Tomcat
### Tomcat configs should be in the tomcat folder like as in the zip folder from the original installer

## Web
### Web is a project made in Jakarta EE or something like that, that builds a WAR file

## Server
### Server is a app for some purpose like persistence, that by some reason is in the same server, but is not mandatory (works in the same network if needed)
