import { Injectable, NestMiddleware, Inject } from '@nestjs/common';
import { Request, Response, NextFunction } from 'express';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import type { Cache } from 'cache-manager';

const IDEMPOTENCY_HEADER = 'x-idempotency-key';
const IDEMPOTENCY_TTL = 86400; // 24 hours in seconds

interface CachedResponse {
  statusCode: number;
  body: unknown;
}

@Injectable()
export class IdempotencyMiddleware implements NestMiddleware {
  constructor(@Inject(CACHE_MANAGER) private cacheManager: Cache) {}

  async use(req: Request, res: Response, next: NextFunction) {
    // Only apply to mutating requests
    if (!['POST', 'PUT', 'PATCH'].includes(req.method)) {
      return next();
    }

    const idempotencyKey = req.headers[IDEMPOTENCY_HEADER] as string;

    // If no idempotency key, proceed normally
    if (!idempotencyKey) {
      return next();
    }

    const cacheKey = `idempotency:${idempotencyKey}`;

    // Check if we have a cached response
    const cachedResponse =
      await this.cacheManager.get<CachedResponse>(cacheKey);

    if (cachedResponse) {
      // Return cached response
      return res.status(cachedResponse.statusCode).json(cachedResponse.body);
    }

    // Store original json method
    const originalJson = res.json.bind(res) as typeof res.json;

    // Override json to cache the response
    res.json = ((body: unknown) => {
      // Cache the response
      const responseToCache: CachedResponse = {
        statusCode: res.statusCode,
        body,
      };

      // Fire and forget - don't await
      void this.cacheManager.set(
        cacheKey,
        responseToCache,
        IDEMPOTENCY_TTL * 1000,
      );

      return originalJson(body);
    }) as typeof res.json;

    next();
  }
}
