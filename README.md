Running ChicagoBoss (erlang web framework) on Heroku
----------------------------------------------------

N.B. This process was an initial attempt and is subject to change :)

To create a new project from scratch:

1. Create a top level project directory.  Add an empty ebin/ directory.
(N.B. also create a dummy file to commit to git)
2. Create a new heroku instance:
    ```
    $ git init
    $ heroku create --stack cedar
    $ heroku config:add BUILDPACK_URL=http://github.com/heroku/heroku-buildpack-erlang.git
    ```
3. Add ChicagoBoss as git submodule (also repeat for cb_admin if required)
    ```
    $ git submodule add https://github.com/evanmiller/ChicagoBoss.git ChicagoBoss
    ```
4. Create app
    ```
    $ cd ChicagoBoss; make; make app PROJECT=myapp
    ```
5. Add Procfile, run.sh from this project - edit project name in run.sh

6. Edit myapp/init.sh - add the following sections: (running erl with the -sname param causes heroku startup to fail)

    ```
    'start-standalone')
           # Start Boss in production mode with no -sname parameter
           echo "starting boss in production mode..."
           START=$(./rebar boss c=start_cmd|grep -v "==>"|perl -pe 's/-sname\s+\S+//')
           $START
           ;;

     'start-dev-standalone')
           # Start Boss in development mode
           START_DEV=$(./rebar boss c=start_dev_cmd|grep -v "==>"|perl -pe 's/-sname\s+\S+//')
           $START_DEV
           ;;
    ```

7. Edit myapp/boss.config
    change boss path line to:
    
    ```
    {path, "../ChicagoBoss"},
    ```

    change port line to:
    
    ```
    {port, {env, "PORT"}},
    ```

    N.B. above currently requires ChicagoBoss HEAD to work

7. Deploy!

    ```
    $ git add .; git push heroku master
    ```

### A few caveats:
- This is based on using the heroku supplied erlang buildpack at: https://github.com/heroku/heroku-buildpack-erlang
- A better solution would be to modify the buildpack to build CB at the compile stage (as opposed to the run stage)
- As such, the above solution may crash at the first deploy due to the app not starting within 60secs.  Run:

    ```
    $ heroku logs -t
    ```
    in a seperate window to keep an eye on the deployment/startup process.

### Heroku specific stuff:

```
$ heroku info
```

within a project will display info about the current project (app url, git url etc)



