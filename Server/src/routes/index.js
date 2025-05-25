import {authRoute} from './authRoute.js'
import { userRoute } from './userRoute.js';
import { solanaRoute } from './solanaRoute.js';

export function route(app){
    app.use('/user', userRoute);
    app.use('/auth', authRoute);
    app.use('/solana', solanaRoute);
}
