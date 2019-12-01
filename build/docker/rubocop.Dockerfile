FROM library/ruby:2.4.6

WORKDIR /opt/gusztavvargadr/rubocop

RUN gem install rubocop --version 0.75.0

ENTRYPOINT [ "rubocop" ]
CMD [ "--version" ]
