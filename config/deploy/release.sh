###########################################
###########################################
##    _____     _                        ##
##   | ___ \   | |                       ##
##   | |_/ /___| | ___  __ _ ___  ___    ##
##   |    // _ \ |/ _ \/ _` / __|/ _ \   ##
##   | |\ \  __/ |  __/ (_| \__ \  __/   ##
##   \_| \_\___|_|\___|\__,_|___/\___|   ##
##                                       ##
###########################################
###########################################

# bin/sh
# https://stackoverflow.com/a/32717779/1143732
# find . -name '*.sh' | xargs git update-index --chmod=+x

echo "Migrating...";
bundle exec rake db:migrate;

echo "Seeding...";
bundle exec rake db:seed;

echo "Precompiling...";
bundle exec rake assets:clobber;
bundle exec rake assets:precompile;

###########################################
###########################################
