<?php

use Illuminate\Support\Facades\Route;

/*
 * Routes are mounted under api/v1/{plugin-slug} (e.g. api/v1/template)
 * and resolve controllers in App\Plugins\Template\Controllers.
 *
 * The "api" middleware group does not authenticate, so wrap
 * protected routes in auth:sanctum.
 */

// Route::middleware('auth:sanctum')->group(function() {
//     Route::get('/example', 'ExampleController@index');
// });
