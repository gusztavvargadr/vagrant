FROM library/ruby:2.4.6

RUN gem install rubocop --version 0.75.0

ENTRYPOINT [ "rubocop" ]
CMD [ "--version" ]
