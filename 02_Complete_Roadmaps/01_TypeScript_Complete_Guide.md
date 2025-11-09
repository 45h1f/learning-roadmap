# 🔷 TypeScript Complete Guide - Master Type-Safe JavaScript

> **Master TypeScript to write safer, more maintainable code and boost your productivity.**

**Last Updated:** January 2025  
**Difficulty:** Beginner to Advanced  
**Time to Complete:** 2-3 weeks

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Why TypeScript?](#why-typescript)
3. [Installation & Setup](#installation--setup)
4. [TypeScript Fundamentals](#typescript-fundamentals)
5. [Advanced Types](#advanced-types)
6. [TypeScript with React](#typescript-with-react)
7. [Best Practices](#best-practices)
8. [Common Patterns](#common-patterns)
9. [Troubleshooting](#troubleshooting)
10. [Projects & Exercises](#projects--exercises)

---

## 🎯 Overview

### What is TypeScript?

**TypeScript = JavaScript + Type System**

```typescript
// JavaScript (no types)
function add(a, b) {
  return a + b;
}
add(5, "10"); // Returns "510" - unexpected!

// TypeScript (with types)
function add(a: number, b: number): number {
  return a + b;
}
add(5, "10"); // Error: Argument of type 'string' is not assignable to 'number'
```

### Key Features

- ✅ **Static Type Checking** - Catch errors before runtime
- ✅ **Better IDE Support** - Autocomplete, refactoring, navigation
- ✅ **Modern JavaScript** - ES6+ features out of the box
- ✅ **Gradual Adoption** - Works with existing JavaScript
- ✅ **Scales Well** - Perfect for large codebases

---

## 💡 Why TypeScript?

### Problems TypeScript Solves

**1. Runtime Errors Become Compile Errors**
```typescript
// JavaScript - Fails at runtime
const user = { name: "John" };
console.log(user.age.toFixed(2)); // TypeError: Cannot read property 'toFixed' of undefined

// TypeScript - Fails at compile time
interface User {
  name: string;
  age?: number; // Optional
}
const user: User = { name: "John" };
console.log(user.age?.toFixed(2)); // Error caught before running!
```

**2. Self-Documenting Code**
```typescript
// Which parameters? What does it return? 🤷
function processUser(user, options) { ... }

// Crystal clear! ✅
function processUser(
  user: User,
  options: ProcessOptions
): Promise<ProcessedUser> { ... }
```

**3. Fearless Refactoring**
```typescript
// Rename a property? TypeScript finds ALL usages
interface User {
  name: string; // Rename to 'fullName'
  // TypeScript will highlight every place that needs updating
}
```

### Industry Adoption

- 🏢 **Used by:** Google, Microsoft, Airbnb, Slack, Shopify, Netflix
- 📈 **Growth:** #3 most loved language (Stack Overflow 2024)
- 💼 **Jobs:** 90%+ of modern frontend jobs require TypeScript

---

## ⚙️ Installation & Setup

### Quick Start (5 minutes)

```bash
# Install TypeScript globally
npm install -g typescript

# Check version
tsc --version

# Create a TypeScript file
echo 'const message: string = "Hello TypeScript!";' > hello.ts

# Compile to JavaScript
tsc hello.ts

# Run the output
node hello.js
```

### Project Setup (Recommended)

```bash
# Create new project
mkdir my-ts-project
cd my-ts-project

# Initialize npm
npm init -y

# Install TypeScript as dev dependency
npm install --save-dev typescript

# Create tsconfig.json
npx tsc --init

# Install Node.js types
npm install --save-dev @types/node
```

### tsconfig.json (Essential Settings)

```json
{
  "compilerOptions": {
    // Language & Environment
    "target": "ES2022",                    // Modern JavaScript
    "lib": ["ES2022", "DOM"],              // Available APIs
    "module": "commonjs",                  // or "ESNext" for modern
    
    // Type Checking (STRICT!)
    "strict": true,                        // Enable ALL strict checks
    "noImplicitAny": true,                 // No implicit 'any' types
    "strictNullChecks": true,              // Handle null/undefined properly
    "strictFunctionTypes": true,           // Strict function checking
    
    // Modules
    "moduleResolution": "node",            // How to resolve imports
    "esModuleInterop": true,               // Better CommonJS imports
    "resolveJsonModule": true,             // Import JSON files
    
    // Output
    "outDir": "./dist",                    // Compiled JS goes here
    "rootDir": "./src",                    // Source TS files here
    "declaration": true,                   // Generate .d.ts files
    "sourceMap": true,                     // For debugging
    
    // Quality of Life
    "skipLibCheck": true,                  // Skip checking .d.ts files
    "forceConsistentCasingInFileNames": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### VS Code Setup (Recommended)

**Extensions:**
- ESLint
- Prettier
- Error Lens (shows errors inline)

**.vscode/settings.json:**
```json
{
  "typescript.tsdk": "node_modules/typescript/lib",
  "typescript.enablePromptUseWorkspaceTsdk": true,
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  }
}
```

---

## 📚 TypeScript Fundamentals

### 1. Basic Types

```typescript
// Primitives
let isDone: boolean = false;
let age: number = 25;
let firstName: string = "John";
let notSure: any = 4; // Avoid 'any' when possible!

// Arrays
let numbers: number[] = [1, 2, 3];
let strings: Array<string> = ["a", "b", "c"];

// Tuples (fixed-length arrays with known types)
let person: [string, number] = ["John", 25];
let rgb: [number, number, number] = [255, 0, 0];

// Enum
enum Color {
  Red,      // 0
  Green,    // 1
  Blue      // 2
}
let c: Color = Color.Green;

// String enums (better!)
enum Direction {
  Up = "UP",
  Down = "DOWN",
  Left = "LEFT",
  Right = "RIGHT"
}

// Void (no return value)
function logMessage(message: string): void {
  console.log(message);
}

// Null and Undefined
let u: undefined = undefined;
let n: null = null;

// Never (function never returns)
function throwError(message: string): never {
  throw new Error(message);
}

// Unknown (safer than 'any')
let value: unknown = "hello";
// value.toUpperCase(); // Error!
if (typeof value === "string") {
  value.toUpperCase(); // OK now!
}
```

### 2. Interfaces

```typescript
// Basic interface
interface User {
  id: number;
  name: string;
  email: string;
}

const user: User = {
  id: 1,
  name: "John Doe",
  email: "john@example.com"
};

// Optional properties
interface Product {
  id: number;
  name: string;
  description?: string; // Optional
  price: number;
}

// Readonly properties
interface Config {
  readonly apiKey: string;
  readonly apiUrl: string;
}

const config: Config = {
  apiKey: "abc123",
  apiUrl: "https://api.example.com"
};
// config.apiKey = "new"; // Error: Cannot assign to 'apiKey'

// Index signatures (dynamic keys)
interface StringMap {
  [key: string]: string;
}

const colors: StringMap = {
  primary: "#007bff",
  secondary: "#6c757d",
  success: "#28a745"
};

// Function types in interfaces
interface MathOperation {
  (x: number, y: number): number;
}

const add: MathOperation = (x, y) => x + y;
const subtract: MathOperation = (x, y) => x - y;

// Extending interfaces
interface Animal {
  name: string;
  age: number;
}

interface Dog extends Animal {
  breed: string;
  bark(): void;
}

const myDog: Dog = {
  name: "Buddy",
  age: 3,
  breed: "Golden Retriever",
  bark() {
    console.log("Woof!");
  }
};
```

### 3. Type Aliases

```typescript
// Simple type alias
type ID = string | number;
type Status = "pending" | "approved" | "rejected";

// Object type alias
type Point = {
  x: number;
  y: number;
};

// Union types
type Result = Success | Error;
type Success = { ok: true; data: any };
type Error = { ok: false; error: string };

// Intersection types
type Name = { name: string };
type Age = { age: number };
type Person = Name & Age; // Has both name AND age

const person: Person = {
  name: "John",
  age: 25
};

// Function type alias
type GreetFunction = (name: string) => string;

const greet: GreetFunction = (name) => {
  return `Hello, ${name}!`;
};
```

### 4. Functions

```typescript
// Function declaration
function add(x: number, y: number): number {
  return x + y;
}

// Arrow function
const multiply = (x: number, y: number): number => x * y;

// Optional parameters
function greet(name: string, greeting?: string): string {
  return `${greeting || "Hello"}, ${name}!`;
}

// Default parameters
function createUser(name: string, role: string = "user"): User {
  return { name, role };
}

// Rest parameters
function sum(...numbers: number[]): number {
  return numbers.reduce((acc, n) => acc + n, 0);
}

// Function overloads
function format(value: string): string;
function format(value: number): string;
function format(value: boolean): string;
function format(value: string | number | boolean): string {
  return String(value);
}

// Async functions
async function fetchUser(id: number): Promise<User> {
  const response = await fetch(`/api/users/${id}`);
  return response.json();
}

// Generic functions
function identity<T>(arg: T): T {
  return arg;
}

const num = identity<number>(5);
const str = identity<string>("hello");
```

### 5. Classes

```typescript
// Basic class
class Person {
  // Properties
  name: string;
  age: number;

  // Constructor
  constructor(name: string, age: number) {
    this.name = name;
    this.age = age;
  }

  // Method
  greet(): string {
    return `Hi, I'm ${this.name}`;
  }
}

// Access modifiers
class BankAccount {
  public accountNumber: string;      // Accessible everywhere
  private balance: number;            // Only within class
  protected owner: string;            // Within class and subclasses

  constructor(accountNumber: string, owner: string) {
    this.accountNumber = accountNumber;
    this.balance = 0;
    this.owner = owner;
  }

  // Public method
  public deposit(amount: number): void {
    this.balance += amount;
  }

  // Private method
  private calculateInterest(): number {
    return this.balance * 0.05;
  }

  // Getter
  get currentBalance(): number {
    return this.balance;
  }

  // Setter
  set currentBalance(value: number) {
    if (value >= 0) {
      this.balance = value;
    }
  }
}

// Shorthand constructor (parameter properties)
class User {
  constructor(
    public id: number,
    public name: string,
    private password: string
  ) {}
}

// Inheritance
class Employee extends Person {
  constructor(
    name: string,
    age: number,
    public employeeId: string
  ) {
    super(name, age);
  }

  // Override method
  greet(): string {
    return `${super.greet()}. Employee ID: ${this.employeeId}`;
  }
}

// Abstract classes
abstract class Shape {
  abstract area(): number;
  
  describe(): string {
    return `Area: ${this.area()}`;
  }
}

class Circle extends Shape {
  constructor(private radius: number) {
    super();
  }

  area(): number {
    return Math.PI * this.radius ** 2;
  }
}

// Implementing interfaces
interface Printable {
  print(): void;
}

class Document implements Printable {
  constructor(private content: string) {}

  print(): void {
    console.log(this.content);
  }
}
```

### 6. Generics

```typescript
// Generic function
function getFirstElement<T>(arr: T[]): T | undefined {
  return arr[0];
}

const firstNum = getFirstElement([1, 2, 3]); // number | undefined
const firstStr = getFirstElement(["a", "b"]); // string | undefined

// Generic interface
interface Box<T> {
  value: T;
}

const numberBox: Box<number> = { value: 123 };
const stringBox: Box<string> = { value: "hello" };

// Generic class
class Queue<T> {
  private items: T[] = [];

  enqueue(item: T): void {
    this.items.push(item);
  }

  dequeue(): T | undefined {
    return this.items.shift();
  }

  peek(): T | undefined {
    return this.items[0];
  }
}

const numberQueue = new Queue<number>();
numberQueue.enqueue(1);
numberQueue.enqueue(2);

// Generic constraints
interface HasLength {
  length: number;
}

function logLength<T extends HasLength>(arg: T): void {
  console.log(arg.length);
}

logLength("hello");     // OK (string has length)
logLength([1, 2, 3]);   // OK (array has length)
// logLength(123);      // Error: number doesn't have length

// Multiple type parameters
function merge<T, U>(obj1: T, obj2: U): T & U {
  return { ...obj1, ...obj2 };
}

const result = merge(
  { name: "John" },
  { age: 25 }
); // { name: string, age: number }

// Generic type aliases
type ApiResponse<T> = {
  data: T;
  status: number;
  message: string;
};

type UserResponse = ApiResponse<User>;
type ProductResponse = ApiResponse<Product[]>;
```

---

## 🚀 Advanced Types

### 1. Union Types

```typescript
// Basic union
type ID = string | number;

function printId(id: ID) {
  if (typeof id === "string") {
    console.log(id.toUpperCase());
  } else {
    console.log(id.toFixed(2));
  }
}

// Discriminated unions (tagged unions)
type Shape = 
  | { kind: "circle"; radius: number }
  | { kind: "rectangle"; width: number; height: number }
  | { kind: "square"; size: number };

function area(shape: Shape): number {
  switch (shape.kind) {
    case "circle":
      return Math.PI * shape.radius ** 2;
    case "rectangle":
      return shape.width * shape.height;
    case "square":
      return shape.size ** 2;
  }
}
```

### 2. Intersection Types

```typescript
type Name = { name: string };
type Age = { age: number };
type Email = { email: string };

type User = Name & Age & Email;

const user: User = {
  name: "John",
  age: 25,
  email: "john@example.com"
};

// Mixin pattern
type Timestamped = {
  createdAt: Date;
  updatedAt: Date;
};

type Product = {
  id: number;
  name: string;
  price: number;
};

type ProductWithTimestamps = Product & Timestamped;
```

### 3. Type Guards

```typescript
// typeof guard
function isString(value: unknown): value is string {
  return typeof value === "string";
}

// instanceof guard
class Dog {
  bark() { console.log("Woof!"); }
}

class Cat {
  meow() { console.log("Meow!"); }
}

function makeSound(animal: Dog | Cat) {
  if (animal instanceof Dog) {
    animal.bark();
  } else {
    animal.meow();
  }
}

// Custom type guard
interface Fish {
  swim(): void;
}

interface Bird {
  fly(): void;
}

function isFish(pet: Fish | Bird): pet is Fish {
  return (pet as Fish).swim !== undefined;
}

function move(pet: Fish | Bird) {
  if (isFish(pet)) {
    pet.swim();
  } else {
    pet.fly();
  }
}

// in operator
type Admin = { role: "admin"; permissions: string[] };
type User = { role: "user"; email: string };

function printInfo(person: Admin | User) {
  if ("permissions" in person) {
    console.log(person.permissions);
  } else {
    console.log(person.email);
  }
}
```

### 4. Utility Types

```typescript
// Partial<T> - Make all properties optional
interface User {
  id: number;
  name: string;
  email: string;
}

type PartialUser = Partial<User>;
// { id?: number; name?: string; email?: string }

function updateUser(id: number, updates: Partial<User>) {
  // Update only provided fields
}

// Required<T> - Make all properties required
type RequiredUser = Required<PartialUser>;

// Readonly<T> - Make all properties readonly
type ReadonlyUser = Readonly<User>;

// Pick<T, K> - Select specific properties
type UserPreview = Pick<User, "id" | "name">;
// { id: number; name: string }

// Omit<T, K> - Remove specific properties
type UserWithoutEmail = Omit<User, "email">;
// { id: number; name: string }

// Record<K, T> - Create object type with specific keys
type Roles = "admin" | "user" | "guest";
type RolePermissions = Record<Roles, string[]>;

const permissions: RolePermissions = {
  admin: ["read", "write", "delete"],
  user: ["read", "write"],
  guest: ["read"]
};

// Exclude<T, U> - Remove types from union
type T1 = "a" | "b" | "c";
type T2 = Exclude<T1, "a">; // "b" | "c"

// Extract<T, U> - Extract types from union
type T3 = Extract<T1, "a" | "b">; // "a" | "b"

// NonNullable<T> - Remove null and undefined
type T4 = string | number | null | undefined;
type T5 = NonNullable<T4>; // string | number

// ReturnType<T> - Get function return type
function createUser() {
  return { id: 1, name: "John" };
}
type User = ReturnType<typeof createUser>;

// Parameters<T> - Get function parameter types
function greet(name: string, age: number) {
  return `Hello ${name}, you are ${age}`;
}
type GreetParams = Parameters<typeof greet>; // [string, number]

// Awaited<T> - Get Promise resolved type
type Response = Promise<{ data: User }>;
type ResolvedResponse = Awaited<Response>; // { data: User }
```

### 5. Mapped Types

```typescript
// Basic mapped type
type ReadonlyUser = {
  readonly [K in keyof User]: User[K];
};

// Make all properties optional
type PartialUser = {
  [K in keyof User]?: User[K];
};

// Transform property types
type StringifiedUser = {
  [K in keyof User]: string;
};

// Conditional mapped type
type Nullable<T> = {
  [K in keyof T]: T[K] | null;
};

// Remove specific properties
type RemoveTimestamps<T> = {
  [K in keyof T as Exclude<K, "createdAt" | "updatedAt">]: T[K];
};

// Getters
type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K];
};

interface Person {
  name: string;
  age: number;
}

type PersonGetters = Getters<Person>;
// {
//   getName: () => string;
//   getAge: () => number;
// }
```

### 6. Conditional Types

```typescript
// Basic conditional type
type IsString<T> = T extends string ? true : false;

type A = IsString<string>; // true
type B = IsString<number>; // false

// Conditional type with inference
type Flatten<T> = T extends Array<infer U> ? U : T;

type Num = Flatten<number[]>; // number
type Str = Flatten<string>; // string

// Practical example: Extract promise type
type UnwrapPromise<T> = T extends Promise<infer U> ? U : T;

type Result1 = UnwrapPromise<Promise<string>>; // string
type Result2 = UnwrapPromise<number>; // number

// Distributive conditional types
type ToArray<T> = T extends any ? T[] : never;

type StrOrNum = string | number;
type Arrays = ToArray<StrOrNum>; // string[] | number[]
```

### 7. Template Literal Types

```typescript
// Basic template literal type
type World = "world";
type Greeting = `hello ${World}`; // "hello world"

// Event names
type EventName = "click" | "focus" | "blur";
type HandlerName = `on${Capitalize<EventName>}`;
// "onClick" | "onFocus" | "onBlur"

// CSS properties
type CSSUnits = "px" | "em" | "rem" | "%";
type Size = `${number}${CSSUnits}`;

const width: Size = "100px"; // OK
const height: Size = "2rem"; // OK
// const invalid: Size = "100"; // Error

// Route patterns
type HttpMethod = "GET" | "POST" | "PUT" | "DELETE";
type Route = `/${string}`;
type Endpoint = `${HttpMethod} ${Route}`;

const endpoint: Endpoint = "GET /api/users"; // OK

// Extract parts of template literal
type ExtractRouteParams<T extends string> = 
  T extends `${string}:${infer Param}/${infer Rest}`
    ? Param | ExtractRouteParams<Rest>
    : T extends `${string}:${infer Param}`
    ? Param
    : never;

type Params = ExtractRouteParams<"/users/:id/posts/:postId">;
// "id" | "postId"
```

---

## ⚛️ TypeScript with React

### 1. Component Types

```typescript
import React, { FC, ReactNode } from 'react';

// Function component with props
interface ButtonProps {
  label: string;
  onClick: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

const Button: FC<ButtonProps> = ({ 
  label, 
  onClick, 
  variant = 'primary',
  disabled = false 
}) => {
  return (
    <button 
      onClick={onClick} 
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {label}
    </button>
  );
};

// Component with children
interface CardProps {
  title: string;
  children: ReactNode;
}

const Card: FC<CardProps> = ({ title, children }) => {
  return (
    <div className="card">
      <h2>{title}</h2>
      {children}
    </div>
  );
};

// Generic component
interface ListProps<T> {
  items: T[];
  renderItem: (item: T) => ReactNode;
}

function List<T>({ items, renderItem }: ListProps<T>) {
  return (
    <ul>
      {items.map((item, index) => (
        <li key={index}>{renderItem(item)}</li>
      ))}
    </ul>
  );
}

// Usage
<List<User>
  items={users}
  renderItem={(user) => <span>{user.name}</span>}
/>
```

### 2. Hooks with TypeScript

```typescript
import { useState, useEffect, useRef, useContext, useReducer } from 'react';

// useState
const [count, setCount] = useState<number>(0);
const [user, setUser] = useState<User | null>(null);

// With initial value inference
const [name, setName] = useState(""); // inferred as string

// useEffect
useEffect(() => {
  const fetchData = async () => {
    const response = await fetch('/api/data');
    const data: DataType = await response.json();
    // ...
  };
  fetchData();
}, []);

// useRef
const inputRef = useRef<HTMLInputElement>(null);
const timerRef = useRef<NodeJS.Timeout | null>(null);

// Usage
inputRef.current?.focus();

// useContext
interface ThemeContextType {
  theme: 'light' | 'dark';
  toggleTheme: () => void;
}

const ThemeContext = React.createContext<ThemeContextType | undefined>(undefined);

function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
}

// useReducer
interface State {
  count: number;
  error: string | null;
}

type Action = 
  | { type: 'increment' }
  | { type: 'decrement' }
  | { type: 'error'; payload: string };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'increment':
      return { ...state, count: state.count + 1 };
    case 'decrement':
      return { ...state, count: state.count - 1 };
    case 'error':
      return { ...state, error: action.payload };
    default:
      return state;
  }
}

const [state, dispatch] = useReducer(reducer, { count: 0, error: null });

// Custom hook
function useFetch<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch(url);
        const json = await response.json();
        setData(json);
      } catch (err) {
        setError(err as Error);
      } finally {
        setLoading(false);
      }
    };
    fetchData();
  }, [url]);

  return { data, loading, error };
}

// Usage
const { data, loading, error } = useFetch<User[]>('/api/users');
```

### 3. Event Handlers

```typescript
import { ChangeEvent, FormEvent, MouseEvent, KeyboardEvent } from 'react';

// Form events
const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
  e.preventDefault();
  // Handle form submission
};

const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
  setName(e.target.value);
};

const handleSelectChange = (e: ChangeEvent<HTMLSelectElement>) => {
  setOption(e.target.value);
};

// Mouse events
const handleClick = (e: MouseEvent<HTMLButtonElement>) => {
  console.log('Clicked at', e.clientX, e.clientY);
};

// Keyboard events
const handleKeyDown = (e: KeyboardEvent<HTMLInputElement>) => {
  if (e.key === 'Enter') {
    // Handle Enter key
  }
};

// Generic event handler
type InputEvent = ChangeEvent<HTMLInputElement | HTMLTextAreaElement>;

const handleInputChange = (e: InputEvent) => {
  const { name, value } = e.target;
  setFormData(prev => ({ ...prev, [name]: value }));
};
```

### 4. Props with HTML Attributes

```typescript
import { ComponentPropsWithoutRef } from 'react';

// Extend native button props
interface CustomButtonProps extends ComponentPropsWithoutRef<'button'> {
  variant: 'primary' | 'secondary';
}

const CustomButton = ({ variant, children, ...props }: CustomButtonProps) => {
  return (
    <button className={`btn-${variant}`} {...props}>
      {children}
    </button>
  );
};

// Extend native input props
interface CustomInputProps extends ComponentPropsWithoutRef<'input'> {
  label: string;
  error?: string;
}

const CustomInput = ({ label, error, ...props }: CustomInputProps) => {
  return (
    <div>
      <label>{label}</label>
      <input {...props} />
      {error && <span className="error">{error}</span>}
    </div>
  );
};
```

---

## ✅ Best Practices

### 1. Type Inference (Let TypeScript Do the Work)

```typescript
// ❌ Don't over-annotate
const name: string = "John";
const age: number = 25;

// ✅ Let TypeScript infer
const name = "John";
const age = 25;

// ❌ Redundant return type
function add(a: number, b: number): number {
  return a + b;
}

// ✅ Inferred return type
function add(a: number, b: number) {
  return a + b; // TypeScript knows it returns number
}

// ⚠️ DO annotate when inference isn't clear
const users: User[] = []; // Good! Empty array needs type
```

### 2. Avoid 'any'

```typescript
// ❌ Never use 'any' if you can avoid it
function processData(data: any) {
  return data.value; // No type safety!
}

// ✅ Use 'unknown' for truly unknown types
function processData(data: unknown) {
  if (typeof data === 'object' && data !== null && 'value' in data) {
    return (data as { value: string }).value;
  }
  throw new Error('Invalid data');
}

// ✅ Or use generics
function processData<T extends { value: any }>(data: T) {
  return data.value;
}
```

### 3. Use Strict Mode

```json
// tsconfig.json - ALWAYS enable strict mode!
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true,
    "strictNullChecks": true,
    "strictFunctionTypes": true,
    "strictPropertyInitialization": true,
    "noImplicitThis": true,
    "alwaysStrict": true
  }
}
```

### 4. Prefer Interfaces for Objects, Types for Everything Else

```typescript
// ✅ Interface for object shapes
interface User {
  id: number;
  name: string;
}

// ✅ Type for unions, intersections, primitives
type ID = string | number;
type Status = 'active' | 'inactive';
type ReadonlyUser = Readonly<User>;

// ✅ Interface can be extended easily
interface Admin extends User {
  permissions: string[];
}

// ⚠️ Type can't be reopened (declaration merging)
// But interfaces can:
interface User {
  email?: string; // Adds email to User interface
}
```

### 5. Const Assertions

```typescript
// Without const assertion
const config = {
  apiUrl: "https://api.example.com",
  timeout: 5000
}; // Type: { apiUrl: string; timeout: number }

// ✅ With const assertion
const config = {
  apiUrl: "https://api.example.com",
  timeout: 5000
} as const;
// Type: { readonly apiUrl: "https://api.example.com"; readonly timeout: 5000 }

// ✅ For arrays
const colors = ['red', 'green', 'blue'] as const;
// Type: readonly ['red', 'green', 'blue']
```

### 6. Non-null Assertion Operator (Use Sparingly!)

```typescript
// ⚠️ Use only when you're CERTAIN value isn't null
function processUser(user: User | null) {
  // Bad: Forces TypeScript to trust you
  console.log(user!.name);
  
  // ✅ Better: Use optional chaining
  console.log(user?.name);
  
  // ✅ Best: Check explicitly
  if (user) {
    console.log(user.name);
  }
}
```

---

## 🎨 Common Patterns

### 1. Builder Pattern

```typescript
class QueryBuilder {
  private query: string = '';
  private params: any[] = [];

  select(fields: string[]): this {
    this.query = `SELECT ${fields.join(', ')} `;
    return this;
  }

  from(table: string): this {
    this.query += `FROM ${table} `;
    return this;
  }

  where(condition: string, ...values: any[]): this {
    this.query += `WHERE ${condition} `;
    this.params.push(...values);
    return this;
  }

  build(): { query: string; params: any[] } {
    return { query: this.query, params: this.params };
  }
}

// Usage
const { query, params } = new QueryBuilder()
  .select(['id', 'name'])
  .from('users')
  .where('age > ?', 18)
  .build();
```

### 2. Factory Pattern

```typescript
interface Animal {
  makeSound(): void;
}

class Dog implements Animal {
  makeSound() {
    console.log('Woof!');
  }
}

class Cat implements Animal {
  makeSound() {
    console.log('Meow!');
  }
}

class AnimalFactory {
  static createAnimal(type: 'dog' | 'cat'): Animal {
    switch (type) {
      case 'dog':
        return new Dog();
      case 'cat':
        return new Cat();
    }
  }
}

const dog = AnimalFactory.createAnimal('dog');
dog.makeSound(); // Woof!
```

### 3. Singleton Pattern

```typescript
class Database {
  private static instance: Database;
  private connection: any;

  private constructor() {
    // Private constructor prevents instantiation
    this.connection = this.createConnection();
  }

  static getInstance(): Database {
    if (!Database.instance) {
      Database.instance = new Database();
    }
    return Database.instance;
  }

  private createConnection() {
    // Create database connection
    return {};
  }

  query(sql: string) {
    // Execute query
  }
}

// Usage
const db1 = Database.getInstance();
const db2 = Database.getInstance();
console.log(db1 === db2); // true (same instance)
```

### 4. Repository Pattern

```typescript
interface Repository<T> {
  find(id: number): Promise<T | null>;
  findAll(): Promise<T[]>;
  create(item: Omit<T, 'id'>): Promise<T>;
  update(id: number, item: Partial<T>): Promise<T>;
  delete(id: number): Promise<void>;
}

class UserRepository implements Repository<User> {
  async find(id: number): Promise<User | null> {
    // Fetch from database
    return null;
  }

  async findAll(): Promise<User[]> {
    // Fetch all from database
    return [];
  }

  async create(user: Omit<User, 'id'>): Promise<User> {
    // Insert into database
    return { id: 1, ...user };
  }

  async update(id: number, user: Partial<User>): Promise<User> {
    // Update in database
    return { id, ...user } as User;
  }

  async delete(id: number): Promise<void> {
    // Delete from database
  }
}
```

### 5. Decorator Pattern (with Experimental Decorators)

```typescript
// tsconfig.json: "experimentalDecorators": true

function Log(target: any, propertyKey: string, descriptor: PropertyDescriptor) {
  const originalMethod = descriptor.value;

  descriptor.value = function(...args: any[]) {
    console.log(`Calling ${propertyKey} with args:`, args);
    const result = originalMethod.apply(this, args);
    console.log(`Result:`, result);
    return result;
  };

  return descriptor;
}

class Calculator {
  @Log
  add(a: number, b: number): number {
    return a + b;
  }
}

const calc = new Calculator();
calc.add(5, 3);
// Logs: Calling add with args: [5, 3]
// Logs: Result: 8
```

---

## 🐛 Troubleshooting

### Common Errors & Solutions

**1. "Type 'null' is not assignable to type 'X'"**

```typescript
// ❌ Error
let user: User = null;

// ✅ Solution: Make it nullable
let user: User | null = null;

// ✅ Or use optional
interface Config {
  user?: User;
}
```

**2. "Object is possibly 'null' or 'undefined'"**

```typescript
// ❌ Error
function greet(name: string | null) {
  return name.toUpperCase(); // Error!
}

// ✅ Solution 1: Optional chaining
function greet(name: string | null) {
  return name?.toUpperCase();
}

// ✅ Solution 2: Nullish coalescing
function greet(name: string | null) {
  return (name ?? 'Guest').toUpperCase();
}

// ✅ Solution 3: Type guard
function greet(name: string | null) {
  if (name) {
    return name.toUpperCase();
  }
  return 'GUEST';
}
```

**3. "Property does not exist on type"**

```typescript
// ❌ Error
interface User {
  name: string;
}
const user: User = { name: 'John', age: 25 }; // Error: 'age' doesn't exist

// ✅ Solution: Add to interface or use type assertion
interface User {
  name: string;
  age: number;
}

// Or use index signature
interface User {
  name: string;
  [key: string]: any;
}
```

**4. "Type 'X' is not assignable to type 'Y'"**

```typescript
// ❌ Error
type Status = 'active' | 'inactive';
let status: Status = 'pending'; // Error!

// ✅ Solution: Use correct type
let status: Status = 'active';

// ✅ Or expand type
type Status = 'active' | 'inactive' | 'pending';
```

**5. "Cannot find module 'X' or its corresponding type declarations"**

```bash
# ✅ Solution: Install types
npm install --save-dev @types/node
npm install --save-dev @types/react
npm install --save-dev @types/express
```

**6. "'this' implicitly has type 'any'"**

```typescript
// ❌ Error
const obj = {
  name: 'John',
  greet() {
    setTimeout(function() {
      console.log(this.name); // Error: 'this' is 'any'
    }, 1000);
  }
};

// ✅ Solution: Use arrow function
const obj = {
  name: 'John',
  greet() {
    setTimeout(() => {
      console.log(this.name); // OK!
    }, 1000);
  }
};
```

---

## 🎯 Projects & Exercises

### Project 1: Todo App with TypeScript

```typescript
// types.ts
export interface Todo {
  id: number;
  title: string;
  completed: boolean;
  createdAt: Date;
}

export type CreateTodoInput = Omit<Todo, 'id' | 'createdAt'>;
export type UpdateTodoInput = Partial<Omit<Todo, 'id' | 'createdAt'>>;

// todoService.ts
class TodoService {
  private todos: Todo[] = [];
  private nextId: number = 1;

  create(input: CreateTodoInput): Todo {
    const todo: Todo = {
      id: this.nextId++,
      ...input,
      createdAt: new Date()
    };
    this.todos.push(todo);
    return todo;
  }

  findAll(): Todo[] {
    return [...this.todos];
  }

  findById(id: number): Todo | undefined {
    return this.todos.find(todo => todo.id === id);
  }

  update(id: number, input: UpdateTodoInput): Todo | undefined {
    const index = this.todos.findIndex(todo => todo.id === id);
    if (index === -1) return undefined;

    this.todos[index] = { ...this.todos[index], ...input };
    return this.todos[index];
  }

  delete(id: number): boolean {
    const index = this.todos.findIndex(todo => todo.id === id);
    if (index === -1) return false;

    this.todos.splice(index, 1);
    return true;
  }
}
```

### Project 2: Type-Safe API Client

```typescript
// api-client.ts
interface ApiResponse<T> {
  data: T;
  status: number;
  message: string;
}

class ApiClient {
  constructor(private baseUrl: string) {}

  async get<T>(endpoint: string): Promise<T> {
    const response = await fetch(`${this.baseUrl}${endpoint}`);
    const json: ApiResponse<T> = await response.json();
    if (response.ok) {
      return json.data;
    }
    throw new Error(json.message);
  }

  async post<T, U>(endpoint: string, body: U): Promise<T> {
    const response = await fetch(`${this.baseUrl}${endpoint}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(body)
    });
    const json: ApiResponse<T> = await response.json();
    if (response.ok) {
      return json.data;
    }
    throw new Error(json.message);
  }
}

// Usage
const api = new ApiClient('https://api.example.com');

interface User {
  id: number;
  name: string;
  email: string;
}

const users = await api.get<User[]>('/users');
const newUser = await api.post<User, Omit<User, 'id'>>('/users', {
  name: 'John',
  email: 'john@example.com'
});
```

### Exercise: Build Your Own

**Task:** Create a type-safe shopping cart system

**Requirements:**
- Product interface (id, name, price, stock)
- Cart class with methods: add, remove, updateQuantity, getTotal
- Type-safe operations (can't add more than stock)
- Calculate total with discounts
- Export/import cart state

---

## 📚 Resources

### Official Documentation
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html) - Complete guide
- [TypeScript Playground](https://www.typescriptlang.org/play) - Test code online
- [DefinitelyTyped](https://github.com/DefinitelyTyped/DefinitelyTyped) - Type definitions

### Books
- "Programming TypeScript" by Boris Cherny
- "Effective TypeScript" by Dan Vanderkam

### Courses
- [TypeScript for JavaScript Programmers](https://www.typescriptlang.org/docs/handbook/typescript-in-5-minutes.html) - Official
- [Total TypeScript](https://www.totaltypescript.com/) - Matt Pocock (Free tutorials)

### Practice
- [Type Challenges](https://github.com/type-challenges/type-challenges) - Test your skills
- [Exercism TypeScript Track](https://exercism.org/tracks/typescript) - Exercises with mentorship

---

## 🎓 Next Steps

1. ✅ **Practice Daily** - Write TypeScript for 30 minutes every day
2. ✅ **Convert a JavaScript Project** - Take an existing JS project and add types
3. ✅ **Build Something Real** - Create a full project with TypeScript
4. ✅ **Read Type Definitions** - Study well-typed libraries (@types/react, etc.)
5. ✅ **Join the Community** - TypeScript Discord, Stack Overflow

---

## ✅ Checklist: TypeScript Mastery

- [ ] Understand basic types (primitives, arrays, objects)
- [ ] Write interfaces and type aliases
- [ ] Use generics effectively
- [ ] Apply utility types (Partial, Pick, Omit, etc.)
- [ ] Create type guards and type narrowing
- [ ] Build React components with proper types
- [ ] Configure tsconfig.json correctly
- [ ] Debug type errors efficiently
- [ ] Use advanced types (mapped, conditional, template literals)
- [ ] Build a full project with TypeScript

---

**Remember: TypeScript is a tool to help you write better code. Don't fight the type system—embrace it! 🚀**

*Last Updated: January 2025*