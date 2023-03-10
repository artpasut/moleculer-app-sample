[![Moleculer](https://badgen.net/badge/Powered%20by/Moleculer/0e83cd)](https://moleculer.services)

# moleculer-app-sample
This is a [Moleculer](https://moleculer.services/)-based microservices project. Generated with the [Moleculer CLI](https://moleculer.services/docs/0.14/moleculer-cli.html).
- [Click to visit this application in live!](https://mock.arta.work/)

## Usage
Start the project with `npm run dev` command. 
After starting, open the http://localhost:3000/ URL in your browser. 
On the welcome page you can test the generated services via API Gateway and check the nodes & services.

In the terminal, try the following commands:
- `nodes` - List all connected nodes.
- `actions` - List all registered service actions.
- `call calculator.info` - Call the `calculator.info` action.
- `call calculator.add --first ' 1 ' --second ' 2 '` - Call the `calculator.add` action with `first` and `second` parameters.
- `call calculator.sub --first ' 1 ' --second ' 2 '` - Call the `calculator.sub` action with `first` and `second` parameters.
- `call math.add --a 1 --b 2` - Call the `math.add` action with `a` and `b` parameters.
- `call math.sub --a 1 --b 2` - Call the `math.sub` action with `a` and `b` parameters.


## Services
- **api**: API Gateway services
- **calculator**: Sample service with `info`, `add` and `sub` actions.
- **math**: Sample DB service with `add` and `sub` actions that will perform calculation.


## Useful links

* Sample App Live: https://mock.arta.work/
* Moleculer website: https://moleculer.services/
* Moleculer Documentation: https://moleculer.services/docs/0.14/

## NPM scripts

- `npm run dev`: Start development mode (load all services locally with hot-reload & REPL)
- `npm run start`: Start production mode (set `SERVICES` env variable to load certain services)
- `npm run cli`: Start a CLI and connect to production. Don't forget to set production namespace with `--ns` argument in script
- `npm run lint`: Run ESLint
- `npm run lint:fix`: Run ESLint with fix
- `npm run ci`: Run continuous test mode with watching
- `npm test`: Run tests & generate coverage report
- `npm run dc:up`: Start the stack with Docker Compose
- `npm run dc:down`: Stop the stack with Docker Compose

## Running services
### Using Docker-compose
The [`docker-compose.yml`](/docker-compose.yml) consists of the following. </br>
* api (api gateway service)
* calculator (calculator service)
* math (math service)
* nats (transporter)
* traefik (proxy)
```bash
npm run dc:up #first time, run this
#made any changes to application
npm run dc:up --build #run this, to rebuild service image and update compose stack
#stop using?
npm run dc:down
```

### Using Github Actions
#### Prerequisite
- Add following variables in github repository actions variables. Click [here](https://docs.github.com/en/actions/learn-github-actions/variables#creating-configuration-variables-for-a-repository), show how to add variables.
  - name: `ECR_REPOSITORY` value: `ECR repository that created from terraform`
  - name: `S3_SCRIPTS_BUCKET_NAME` value: `S3 scripts bucket that created from terraform`
  - name: `API_INSTACE_ID` value: `EC2 instance id of api service that created from terraform`
  - name: `CALCULATOR_INSTACE_ID` value: `EC2 instance id of calculator service that created from terraform`
  - name: `MATH_INSTACE_ID` value: `EC2 instance id of math service that created from terraform`
  - name: `NATS_INSTACE_ID` value: `EC2 instance id of NATS service that created from terraform`

The Github Actions consists of following steps. [`(ci.yml)`](/.github/workflows/ci.yml) </br>
1. Running test jobs which includes ESLint, unit test coverage.
2. Building service container image and push to ECR.
3. Deploy NATS service with image from dockerhub using AWS System manager session. 
4. Deploy API, calculator, math service using AWS System manager session.

#### Running Github Actions
```
There are two ways to run.
1. Merge, push to main branch will trigger Github actions to make a deployment.
2. PR will trigger Github actions to run only test job.
```