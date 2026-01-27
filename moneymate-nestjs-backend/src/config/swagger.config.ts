import { INestApplication } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { SwaggerCustomOptions } from '@nestjs/swagger/dist/interfaces/swagger-custom-options.interface';
import { FastifyRequest, FastifyReply, FastifyInstance } from 'fastify';
import { config } from 'dotenv';
config();

const APP_NAME = 'API Money Mate';
const APP_VERSION = '1.0.0';

// Basic authentication credentials from environment variables
const SWAGGER_USERNAME = process.env.USER_SWAGGER;
const SWAGGER_PASSWORD = process.env.PASSWORD_SWAGGER;

// Basic authentication function
function basicAuth(
  request: FastifyRequest,
  reply: FastifyReply,
  done: () => void,
) {
  const authHeader = request.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Basic ')) {
    reply.header('WWW-Authenticate', 'Basic realm="Swagger Documentation"');
    return reply
      .status(401)
      .send({ message: 'Unauthorized access to Swagger documentation' });
  }

  const credentials = Buffer.from(authHeader.substring(6), 'base64').toString();
  const [username, password] = credentials.split(':');

  if (username !== SWAGGER_USERNAME || password !== SWAGGER_PASSWORD) {
    reply.header('WWW-Authenticate', 'Basic realm="Swagger Documentation"');
    return reply.status(401).send({ message: 'Invalid credentials' });
  }

  done();
}

export const useSwagger = (
  app: INestApplication,
  swaggerOptions?: SwaggerCustomOptions,
) => {
  const isProd = process.env.NODE_ENV === 'production';

  const builder = new DocumentBuilder()
    .setTitle(APP_NAME)
    .setDescription(`The ${APP_NAME} description`)
    .setExternalDoc('JSON DOCUMENTS', '/api/docs-json')
    .setVersion(APP_VERSION)
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'Authorization',
        description: 'Enter JWT token',
        in: 'header',
      },
      'bearer',
    );

  const options = builder.build();
  const document = SwaggerModule.createDocument(app, options);

  if (isProd) {
    const fastifyApp = app.getHttpAdapter().getInstance() as FastifyInstance;

    // Add preHandler hook for /api/docs route (but not /api/docs-json)
    fastifyApp.addHook(
      'preHandler',
      (request: FastifyRequest, reply: FastifyReply, done: () => void) => {
        if (
          request.url.startsWith('/api/docs') &&
          !request.url.startsWith('/api/docs-json')
        ) {
          return basicAuth(request, reply, done);
        }
        done();
      },
    );
  }

  SwaggerModule.setup('api/docs', app, document, {
    swaggerOptions: { persistAuthorization: true },
    ...swaggerOptions,
  });
};
