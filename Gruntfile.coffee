# Grunt: The JavaScript Task Runner (http://gruntjs.com/)
# Why use a task runner?
#     In one word: automation. The less work you have to do when performing
#     repetitive tasks like minification, compilation, unit testing, linting,
#     etc, the easier your job becomes. After you've configured it, a task
#     runner can do most of that mundane work for you—and your team—with
#     basically zero effort.
# Why use Grunt?
#     The Grunt ecosystem is huge and it's growing every day. With literally
#     hundreds of plugins to choose from, you can use Grunt to automate just
#     about anything with a minimum of effort. If someone hasn't already built
#     what you need, authoring and publishing your own Grunt plugin to npm
#     is a breeze.
'use strict'

# http://gruntjs.com/api/grunt
# Grunt exposes all of its methods and properties on the grunt object that gets
# passed into the module.exports function exported in your Gruntfile.
module.exports = (grunt) =>

    # show elapsed time at the end
    require('time-grunt') grunt

    # load all grunt tasks
    require('load-grunt-tasks') grunt

    # http://gruntjs.com/api/grunt.config#grunt.config.init
    # grunt.initConfig is an alias for the grunt.config.init method.
    grunt.initConfig

        # Easy access to this package's details, e.g. name, version number, etc.
        pkg: grunt.file.readJSON 'package.json'

        # grunt-bower-task: https://github.com/yatskevich/grunt-bower-task
        # Install Bower packages. Smartly.
        bower:

            install:
                options:
                    copy: false

        # grunt-contrib-clean: https://github.com/gruntjs/grunt-contrib-clean
        # Clear files and folders.
        clean:

            dist:
                files: [
                    dot: true
                    src: ['<%= pkg.dist %>/*']
                ]

            temp:
                files: [
                    dot: true
                    src: ['<%= pkg.temp %>/*']
                ]

        # grunt-contrib-coffee: https://github.com/gruntjs/grunt-contrib-coffee
        # Compile CoffeeScript files to JavaScript.
        coffee:

            demo:
                expand: true
                cwd: '<%= pkg.demo %>'
                src: ['**/*.{coffee,coffee.md,litcoffee}']
                dest: '<%= pkg.temp %>'
                ext: '.js'

            dist:
                expand: true
                cwd: '<%= pkg.src %>'
                src: ['GoogleAnalytics.{coffee,coffee.md,litcoffee}']
                dest: '<%= pkg.dist %>'
                ext: '.js'

            temp:
                expand: true
                cwd: '<%= pkg.src %>'
                src: ['**/*.{coffee,coffee.md,litcoffee}']
                dest: '<%= pkg.temp %>'
                ext: '.js'

            test:
                expand: true
                cwd: '<%= pkg.test %>'
                src: ['**/*.{coffee,coffee.md,litcoffee}']
                dest: '<%= pkg.temp %>'
                ext: '.js'

        # grunt-coffeelint: https://github.com/vojtajina/grunt-coffeelint
        # Lint your CoffeeScript using grunt.js and coffeelint.
        coffeelint:
            options:
                indentation:
                    value: 4
                max_line_length:
                    value: 120
            all: [
                'Gruntfile.coffee'
                '<%= pkg.src %>/**/*.coffee'
                '<%= pkg.test %>/**/*.coffee'
            ]

        # grunt-concurrent: https://github.com/sindresorhus/grunt-concurrent
        # Run grunt tasks concurrently.
        concurrent:

            demo: [
                'coffee:demo'
                'coffee:temp'
            ]

            temp: [
                'coffee:temp'
            ]

            test: [
                'coffee:temp'
                'coffee:test'
            ]

        # grunt-contrib-connect: https://github.com/gruntjs/grunt-contrib-connect
        # Start a connect web server.
        connect:

            options:
                port: 9000
                livereload: 35729

                # change this to '0.0.0.0' to access the server from outside
                hostname: 'localhost'

            livereload:
                options:
                    open: true
                    base: [
                        'bower_components'
                        '<%= pkg.demo %>'
                        '<%= pkg.temp %>'
                    ]

            test:
                options:
                    base: [
                        'bower_components'
                        '<%= pkg.test %>'
                        '<%= pkg.temp %>'
                    ]

        # grunt-contrib-copy: https://github.com/gruntjs/grunt-contrib-copy
        # Copy files and folders.
        copy:
            eventEmitter:
                src: 'bower_components/event-emitter/dist/EventEmitter.js'
                dest: '.tmp/event-emitter/dist/EventEmitter.js'

        # grunt-contrib-jshint: https://github.com/gruntjs/grunt-contrib-jshint
        # Validate files with JSHint.
        jshint:
            options:
                jshintrc: '.jshintrc'

            temp:
                src: [
                    '<%= pkg.temp %>/**/*.js'
                ]

        # grunt-markdown: https://github.com/treasonx/grunt-markdown
        # Markdown gruntjs task with code highlighting
        markdown:
            files:
                src: 'README.md'
                dest: '<%= pkg.dist %>/README.html'

        # grunt-mocha-phantomjs: https://github.com/jdcataldo/grunt-mocha-phantomjs
        # A simple grunt wrapper for mocha-phantomjs to allow for ci integration.
        mocha_phantomjs:
            all:
                options:
                    urls: ['http://<%= connect.test.options.hostname %>:<%= connect.test.options.port %>/index.html']

        # grunt-contrib-requirejs https://github.com/gruntjs/grunt-contrib-requirejs
        # Optimize RequireJS projects using r.js.
        requirejs:
            test:
                options:
                    name: 'main'
                    baseUrl: '<%= pkg.temp %>'
                    mainConfigFile: '<%= pkg.temp %>/main.js'
                    out: '<%= pkg.temp %>/optimized.js'
                    optimize: 'none'
                    findNestedDependencies: false # Does not work with this enabled

        # grunt-contrib-watch: https://github.com/gruntjs/grunt-contrib-watch
        # Run predefined tasks whenever watched file patterns are added, changed or deleted.
        watch:

            coffee:
                files: [
                    '<%= pkg.src %>/**/*.{coffee,coffee.md,litcoffee}'
                    '<%= pkg.test %>/**/*.{coffee,coffee.md,litcoffee}'
                ]
                tasks: ['coffee:temp', 'coffee:test']

            # https://github.com/gruntjs/grunt-contrib-watch#optionslivereload
            # Reload the webpage using the development server's livereload
            livereload:
                options:
                    livereload: '<%= connect.options.livereload %>'

                files: [
                    '<%= pkg.demo %>/**/*.html'
                    '<%= pkg.temp %>/**/*.js'
                    '<%= pkg.test %>/**/*.html'
                ]

    # http://gruntjs.com/api/grunt.task#grunt.task.registertask
    # grunt.registerTask is an alias for the grunt.task.registerTask method.
    # Register an "alias task" or a task function.
    grunt.registerTask 'server', [
        'clean:temp'
        'concurrent:demo'
        'connect:livereload'
        'watch'
    ]

    grunt.registerTask 'test', [
        'clean:temp'
        'concurrent:test'
        'connect:test'
        'mocha_phantomjs'
    ]

    grunt.registerTask 'build', [
        'clean'
        'coffee:dist'
        'markdown'
    ]

    # When grunt is run without any arguments
    grunt.registerTask 'default', [
        'clean'
        'bower'
        'coffee'
        'coffeelint'
        'jshint'
        'test'
        'copy'
        'requirejs'
        'build'
    ]

    grunt.registerTask 'travis', 'Travis build tasks', ['default']
