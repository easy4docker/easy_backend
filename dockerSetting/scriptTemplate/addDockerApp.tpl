# -- Add docker app ... <%=@serverName %> --

cd <%=@dockerSettingPath %>

docker container stop <%=@siteContainer %>

docker container rm <%=@siteContainer %>

docker container stop <%=@siteContainer %>_eng

docker container rm <%=@siteContainer %>_eng

docker image rm -f <%=@siteImage %>

docker image rm -f <%=@siteImage %>_eng

docker build -f <%=@dockerFile %> -t <%=@siteImage %> .

docker build -f <%=@dockerFile %>CloudEngine -t <%=@siteImage %>_eng .

docker run -d -e MYSQL_ROOT_HOST="<%=@mainIP%>" -e MYSQL_ROOT_PASSWORD=<%=@keyCode%> <%=@cmdPorts%> -v "<%=@dockerCodePath%>":/var/_localApp -v "<%=@dockerDataPath%>":/var/lib/mysql  --network network_easydocker --name <%=@siteContainer %>  <%=@siteImage %> 

docker run -d -e MYSQL_ROOT_HOST="<%=@mainIP%>" -e MAIN_PORT="<%=@mainPort%>" -e MYSQL_ROOT_PASSWORD=<%=@keyCode%> <%=@engPorts%> -v "<%=@dockerCodePath%>":/var/_localApp -v "<%=@dockerDataPath%>":/var/_localAppData -v "<%=@dockerEnvPath%>":/var/_localAppEnv --network network_easydocker --name <%=@siteContainer %>_eng  <%=@siteImage %>_eng
