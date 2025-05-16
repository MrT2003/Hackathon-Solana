import {authRoute} from './authRoute.js'
import { userRoute } from './userRoute.js';

export function route(app){
    app.use('/user', userRoute)
    app.use('/auth', authRoute);
}
