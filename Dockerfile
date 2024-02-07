# syntax=docker/dockerfile:1
FROM ruby:3.3.0
RUN apt-get update -qq && apt-get install -y postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
RUN gem install bootstrap -v 5.3.2

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Set files owner
RUN chown -R $USER:$USER .

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]