# Texting service

This is a Rails API designed to send text messages. The API serves as a messaging service that receives messages from clients and subsequently dispatches these messages to multiple SMS providers. Its primary function is to facilitate the seamless delivery of text messages to the intended recipients using various SMS providers as delivery channels.

## Table of contents

- Requirements
- Recommended modules
- Installation
- Configuration
- Troubleshooting

# Requirements

This module requires the following:

- Ruby version 3.1.2
- Ngrok
- SQLite 3

# Installation

1. Clone the Repository: Open your terminal and navigate to the directory where you want to store the Rails application. Then, use the git clone command to clone the existing repository: `git clone https://github.com/imhilla/texting_service.git`

2. Navigate to the App Directory: Change into the newly cloned app directory: `cd texting_service`
3. Install Dependencies: In your app directory, run the following command to install the required Ruby gems specified in the Gemfile: `bundle install`
4. Set Up the Database: Run the following command to create the database and set up the initial database schema:
   `rails db:create db:migrate`
5. Start the Rails Server: Now, start the Rails server using the following command `rails server` Your Rails application should now be up and running. Access it by visiting http://localhost:3000 in your web browser.

6. Set up Ngrok. To expose the delivery_status route using ngrok, follow these steps:

   - First, download and install ngrok from the official website (https://ngrok.com/download). Ngrok allows you to expose your local server to the internet with a public URL, which is useful for testing webhooks and other external API integrations.
   - Start the Rails Server
     Ensure that your Rails server is running. If it's not already running, start it using the following command in your Rails app directory.
   - Expose the Rails Server with ngrok
     Open a new terminal window, navigate to the directory where ngrok is installed, and run the following command to expose your local Rails server. `ngrok http 3000`

   - Here, 3000 is the default port on which the Rails server runs. If your Rails server is running on a different port (e.g., 4000), replace 3000 with the appropriate port number.
   - Obtain the Public URL
     After running the ngrok command, you will see an ngrok-generated public URL in the terminal. It will look something like http://abcd1234.ngrok.io.
   - Update call_back_url - Head over to `app/controllers/concerns` and update the call_back_url example `call_back_url = "https://5ab8-41-80-118-187.ngrok.io/delivery_status` with your new ngrok web hook.

# Configuration

Before you start using the api you will need to run a few end points to set up providers. To load balance
the app has been configured to allow url porviders to be created throught end points, without it the sms service will not work correctly. head over<a href="https://crimson-moon-436442.postman.co/workspace/My-Workspace~e24b807c-503a-4cb0-8ce6-3e1c28b8e1eb/collection/13004566-87d5e060-ebcd-4538-b266-a0c2e5c6e4f9?action=share&creator=13004566"> here</a>, and send a POST request to `http://127.0.0.1:3000/providers` make sure you switch the url of the provider to set up the secon provider.

      - Example for provider one `{ "name": "provider2", "message_count": 0, "url": "https://mock-text-provider.parentsquare.com/provider1"}`

      - Example for provider two `{ "name": "provider2", "message_count": 0, "url": "https://mock-text-provider.parentsquare.com/provider2"}`

# Troubleshooting

Incase you experience any issues please reach out to me for clarification.
