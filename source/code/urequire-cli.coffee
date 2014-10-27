# var VERSION = 'x.x.x' injected by grunt:concat
process.title = "urequire-cli"

_ = (_B = require 'uberscore')._
l = new _B.Logger "urequire-cli"
fs = require 'fs'

urequire = require './localUrequire'

printVersions = ->
  unless urequire
    l.err  "Cant find local `urequire`."
    l.warn "Make sure you `npm install urequire --save-dev` LOCALLY (without -g)"
  l.ok "urequire-cli v#{VERSION}" + if urequire then ", uRequire v#{urequire.VERSION}" else ''

commander = require 'commander'

toArray = (val)->
  if _.isArray val
    val
  else
    _.map val.split(','), (v)->
      if _.isString(v) then v.trim() else v

config = {}

commander
  .version(VERSION)
  .option('-B, --ver', 'Print urequire-cli & urequire versions.')
  .option('-o, --dstPath <dstPath>', 'Output converted files onto this directory')
  .option('-f, --forceOverwriteSources', 'Overwrite *source* files (-o not needed & ignored)', undefined)
  .option('-v, --verbose', 'Print module processing information', undefined)
  .option('-d, --debugLevel <debugLevel>', 'Pring debug information (0-100)', undefined)
  .option('-n, --noExports', 'Ignore all web `rootExports` in module definitions', undefined)
  .option('-r, --webRootMap <webRootMap>', "Where to map `/` when running in node. On RequireJS its http-server's root. Can be absolute or relative to bundle. Defaults to bundle.", undefined)
  .option('-s, --scanAllow', "By default, ALL require('') deps appear on []. to prevent RequireJS to scan @ runtime. With --s you can allow `require('')` scan @ runtime, for source modules that have no [] deps (eg nodejs source modules).", undefined)
  .option('-a, --allNodeRequires', 'Pre-require all deps on node, even if they arent mapped to parameters, just like in AMD deps []. Preserves same loading order, but a possible slower starting up. They are cached nevertheless, so you might gain speed later.', undefined)
  .option('-p, --dummyParams', 'Add dummy params for deps that have no corresponding param in the AMD define Array.', undefined)
  .option('-t, --template <template>', 'Template (AMD, UMD, nodejs), to override a `configFile` setting. Should use ONLY with `config`', undefined)
  .option('-O, --optimize', 'Pass through uglify2 while saving/optimizing - currently works only for `combined` template, using r.js/almond.', undefined)
  .option('-C, --continue', 'Dont bail out while processing (module processing/conversion errors)', undefined)
  .option('-w, --watch [debounceWaitMs]', "Watch for file changes in `bundle.path` & rebuild them. `debounceWaitMs` is how many milliseconds to delay each new build, waiting for more file changes.", undefined)
  .option('-b, --bare', "Don't enclose AMD/UMD modules in Immediately Invoked Function Expression (safety wraper).", undefined)
  .option('-f, --filez', "NOT IMPLEMENTED (in CLI - use a config file or grunt-urequire). Process only modules/files in filters - comma seprated list/Array of Strings or Regexp's", toArray)
  .option('-j, --jsonOnly', 'NOT IMPLEMENTED. Output everything on stdout using json only. Usefull if you are building build tools', undefined)
  .option('-e, --verifyExternals', 'NOT IMPLEMENTED. Verify external dependencies exist on file system.', undefined)

for tmplt in (urequire?.Build?.templates) or ['UMD', 'UMDplain', 'AMD', 'nodejs', 'combined']
  do (tmplt)->
    commander
      .command("#{tmplt} <path>")
      .description("Converts all modules in <path> using '#{tmplt}' template.")
      .action (path)->
        config.template = tmplt
        config.path = path

commander
  .command('config <configFiles...>')
  .action (cfgFiles)->
    config.derive = toArray cfgFiles

commander.on '--help', ->
  l.log """
  Examples:
                                                                                         \u001b[32m
    $ urequire UMD path/to/amd/moduleBundle -o umd/moduleBundle                          \u001b[0m
                    or                                                                   \u001b[32m
    $ urequire AMD path/to/moduleBundle -f                                               \u001b[0m
                    or                                                                   \u001b[32m
    $ urequire config path/to/configFile.json,anotherConfig.js,masterConfig.coffee -d 30 \u001b[0m

  *Notes: Command line values have precedence over configFiles;
          Values on config files on the left have precedence over those on the right (deeply traversing).*

  Module files in your bundle can conform to the *standard AMD* format: \u001b[36m
      // standard AMD module format - unnamed or named (not recommended by AMD)
      define(['dep1', 'dep2'], function(dep1, dep2) {...});  \u001b[0m

  Alternativelly modules can use the *standard nodejs/CommonJs* format: \u001b[36m
      var dep1 = require('dep1');
      var dep2 = require('dep2');
      ...
      module.exports = {my: 'module'} \u001b[0m

  Finally, a 'relaxed' format can be used (combination of AMD+commonJs), along with asynch requires, requirejs plugins, rootExports + noConflict boilerplate, exports.bundle and much more - see the docs. \u001b[36m
      // uRequire 'relaxed' modules format
    - define(['dep1', 'dep2'], function(dep1, dep2) {
        ...
        // nodejs-style requires, with no side effects
        dep3 = require('dep3');
        ....
        // asynchronous AMD-style requires work in nodejs
        require(['someDep', 'another/dep'], function(someDep, anotherDep){...});

        // RequireJS plugins work on web + nodejs
        myJson = require('json!ican/load/requirejs/plugins/myJson.json');
        ....
        return {my: 'module'};
      }); \u001b[0m

  Notes:
    --forceOverwriteSources (-f) is useful if your sources are not `real sources`  eg. you use coffeescript :-).
      WARNING: -f ignores --dstPath

    - Your source can be coffeescript (more will follow) - .coffee files are internally translated to js.

    - configFiles can be written as a .js module, .coffee module, json and much more - see 'butter-require'
  """
  printVersions()

commander.parse process.argv

#hack to get cmd options only ['verbose', 'scanAllow', 'dstPath', ...] etc
CMDOPTIONS = _.map(commander.options, (o)-> o.long.slice 2)

# overwrite anything on config's root by cmdConfig - BundleBuilder handles the rest
_.extend config, _.pick(commander, CMDOPTIONS)
delete config.version

if _.isEmpty(config) or _.isEqual(_.keys(config), ['ver'])
  if not config.ver
    l.er """
      No CLI options or config file specified.
      Not looking for any default config file in this urequire-cli version.
      Type -h if U R after help!"
    """
  printVersions()
else
  if not urequire
    printVersions()
    process.exit 1
  else
    if config.debugLevel?
      _B.Logger.addDebugPathLevel 'uRequire', config.debugLevel * 1 # cast to Number or NaN

    if config.verbose
      printVersions()
      l.verbose 'uRequire-cli called with cmdConfig=\n', config

    config.done = (doneValue)->
      b =
        startDate: bb.build?.startDate or new Date()
        count: bb.build?.count or 0
      if (doneValue isnt false) or (not doneValue instanceof Error)
        doneMsg = -> "uRequire-cli done() ##{b.count} successfully in #{(new Date() - b.startDate) / 1000 }secs."
        if bb?.l
          if bb.l.deb 10
            l.deb doneMsg()
        else
          l.verbose doneMsg()
      else
        l.er "uRequire-cli done() ##{b.count} with errors in #{(new Date() - b.startDate) / 1000 }secs."

    config.watch = parseInt config.watch if not isNaN parseInt config.watch # cast watch to number

    bb = new urequire.BundleBuilder [config]
    possPromise = bb.buildBundle()

    # call watch, on different urequire versions
    if (bb.build.watch is true) or
       (bb.build.watch?.enabled is true) or
       (_.isNumber bb.build.watch)

      if _.isFunction possPromise?.finally
        possPromise.finally -> bb.watch bb.build.watch
      else
        bb.watch bb.build.watch