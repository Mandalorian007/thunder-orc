---
feature_name: "frontend-dashboard"
feature_code: "DASH"
feature_port: 3100
feature_branch: "feature/frontend-dashboard"
dependencies: ["AUTH"]
environment:
  NODE_ENV: "development"
  NEXT_PUBLIC_API_URL: "http://localhost:3000/api"
  NEXT_PUBLIC_APP_NAME: "Thunder Dashboard"
  DATABASE_URL: "postgresql://localhost:5432/dashboard_db"
---

# Frontend Dashboard Feature

## Overview
A modern, responsive Next.js 14 frontend application with TypeScript, featuring a comprehensive dashboard interface, real-time data visualization, and robust testing coverage.

## Technology Stack
- **Framework**: Next.js 14 (App Router)
- **Language**: TypeScript
- **Styling**: Tailwind CSS + shadcn/ui components
- **State Management**: Zustand + React Query (TanStack Query)
- **Authentication**: NextAuth.js integration with AUTH feature
- **Database**: PostgreSQL with Prisma ORM
- **Testing**: Vitest + React Testing Library + Playwright
- **CI/CD**: GitHub Actions

## Requirements

### Core Features
- **Authentication Integration**: Seamless login/logout with AUTH service
- **Dashboard Layout**: Responsive sidebar navigation with breadcrumbs
- **Data Visualization**: Interactive charts and graphs using Recharts
- **Real-time Updates**: WebSocket integration for live data
- **User Management**: Profile settings and preferences
- **Search & Filtering**: Advanced search with filters and sorting
- **Export Functionality**: CSV/PDF export capabilities
- **Dark/Light Mode**: Theme switching with persistence

### Technical Requirements
- **Performance**: Lighthouse score > 90 for all categories
- **Accessibility**: WCAG 2.1 AA compliance
- **Mobile Responsiveness**: Mobile-first design approach
- **SEO**: Proper meta tags and structured data
- **Error Handling**: Comprehensive error boundaries and fallbacks
- **Loading States**: Skeleton screens and loading indicators
- **Caching**: Efficient data caching and invalidation

## Project Structure
```
frontend-dashboard/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── (auth)/            # Auth route group
│   │   ├── dashboard/         # Dashboard pages
│   │   ├── layout.tsx         # Root layout
│   │   └── page.tsx           # Home page
│   ├── components/            # Reusable components
│   │   ├── ui/               # shadcn/ui components
│   │   ├── charts/           # Chart components
│   │   ├── forms/            # Form components
│   │   └── layout/           # Layout components
│   ├── lib/                   # Utility functions
│   │   ├── auth.ts           # NextAuth configuration
│   │   ├── db.ts             # Database connection
│   │   ├── utils.ts          # Helper functions
│   │   └── validations.ts    # Zod schemas
│   ├── hooks/                 # Custom React hooks
│   ├── store/                 # Zustand stores
│   ├── types/                 # TypeScript definitions
│   └── styles/                # Global styles
├── prisma/                    # Database schema
├── tests/                     # Test files
│   ├── unit/                 # Unit tests
│   ├── integration/          # Integration tests
│   └── e2e/                  # Playwright tests
├── public/                    # Static assets
└── docs/                      # Documentation
```

## API Integration
- **Base URL**: `http://localhost:3000/api`
- **Authentication**: JWT tokens from AUTH service
- **Error Handling**: Standardized error responses
- **Rate Limiting**: Respect API rate limits

### Key Endpoints
- `GET /api/v1/dashboard/stats` - Dashboard metrics
- `GET /api/v1/dashboard/charts` - Chart data
- `GET /api/v1/users/profile` - User profile
- `PUT /api/v1/users/profile` - Update profile
- `GET /api/v1/activities` - Activity feed
- `POST /api/v1/export` - Data export

## Database Schema
### Dashboard Settings Table
```sql
CREATE TABLE dashboard_settings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    theme VARCHAR(20) DEFAULT 'light',
    sidebar_collapsed BOOLEAN DEFAULT FALSE,
    default_view VARCHAR(50) DEFAULT 'overview',
    chart_preferences JSONB DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### User Activities Table
```sql
CREATE TABLE user_activities (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50),
    resource_id INTEGER,
    metadata JSONB DEFAULT '{}',
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

## Testing Strategy

### Unit Tests (Vitest + React Testing Library)
```bash
# Run unit tests
npm run test:unit

# Watch mode
npm run test:unit:watch

# Coverage report
npm run test:unit:coverage
```

**Coverage Requirements**:
- Components: 90% line coverage
- Hooks: 95% line coverage
- Utilities: 100% line coverage
- Stores: 90% line coverage

**Test Categories**:
- Component rendering and props
- User interactions and events
- State management logic
- API integration mocking
- Form validation
- Error boundary testing

### Integration Tests (Playwright)
```bash
# Run integration tests
npm run test:integration

# Run specific test file
npm run test:integration -- dashboard.spec.ts

# Debug mode
npm run test:integration:debug
```

**Test Scenarios**:
- User authentication flow
- Dashboard navigation
- Data loading and display
- Form submissions
- Real-time updates
- Error handling
- Mobile responsiveness

### End-to-End Tests (Playwright)
```bash
# Run e2e tests
npm run test:e2e

# Run in headed mode
npm run test:e2e:headed

# Generate test report
npm run test:e2e:report
```

**E2E Test Coverage**:
- Complete user journeys
- Cross-browser compatibility
- Performance testing
- Accessibility testing
- Visual regression tests

## Development Workflow

### Setup Commands
```bash
# Install dependencies
npm install

# Setup database
npm run db:setup

# Run database migrations
npm run db:migrate

# Seed development data
npm run db:seed

# Start development server
npm run dev
```

### Quality Assurance
```bash
# Type checking
npm run type-check

# Linting
npm run lint

# Format code
npm run format

# Build for production
npm run build

# Run all tests
npm run test:all
```

### Git Hooks
- **Pre-commit**: Lint, format, and type-check
- **Pre-push**: Run unit tests and build
- **Commit-msg**: Enforce conventional commits

## Performance Targets
- **First Contentful Paint**: < 1.5s
- **Largest Contentful Paint**: < 2.5s
- **Cumulative Layout Shift**: < 0.1
- **Time to Interactive**: < 3.0s
- **Bundle Size**: < 300KB (gzipped)

## Accessibility Requirements
- **Keyboard Navigation**: Full keyboard accessibility
- **Screen Reader Support**: Proper ARIA labels and roles
- **Color Contrast**: WCAG AA compliance (4.5:1 ratio)
- **Focus Management**: Visible focus indicators
- **Form Labels**: Proper form labeling and error messages

## Security Considerations
- **XSS Prevention**: Sanitize user input
- **CSRF Protection**: NextAuth.js built-in protection
- **Content Security Policy**: Strict CSP headers
- **Data Validation**: Client and server-side validation
- **Secure Headers**: HSTS, X-Frame-Options, etc.

## Monitoring & Analytics
- **Error Tracking**: Sentry integration
- **Performance Monitoring**: Web Vitals tracking
- **User Analytics**: Privacy-focused analytics
- **Logging**: Structured logging with context

## Documentation Requirements
- **Component Storybook**: Interactive component documentation
- **API Documentation**: OpenAPI/Swagger integration
- **User Guide**: End-user documentation
- **Developer Guide**: Setup and contribution guidelines
- **Deployment Guide**: Production deployment instructions

## Deployment Configuration
- **Environment Variables**: Secure environment management
- **Docker**: Multi-stage production build
- **CI/CD Pipeline**: Automated testing and deployment
- **Health Checks**: Application health monitoring
- **Backup Strategy**: Database backup procedures

## Success Criteria
- All tests passing with required coverage
- Lighthouse performance score > 90
- Zero accessibility violations
- Responsive design across all devices
- Successful integration with AUTH service
- Production-ready deployment configuration
- Complete documentation and user guides