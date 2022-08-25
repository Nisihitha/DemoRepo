import { BrowserModule } from '@angular/platform-browser';
import { NgModule, APP_INITIALIZER } from '@angular/core';
import { environment } from 'src/environments/environment';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { InitConfigService } from '@bristlecone-labs/neo-app-sdk';
import { TokenInterceptor } from '@bristlecone-labs/neo-app-sdk';
import { MessageService } from '@bristlecone-labs/neo-app-sdk';
import { NeoAppsdkLoginModule } from '@bristlecone-labs/neo-app-sdk';
import { AuthGuard } from '@bristlecone-labs/neo-app-sdk';
import { NeoUtilService } from '@bristlecone-labs/neo-app-sdk';
import { HTTP_INTERCEPTORS } from '@angular/common/http';
import { LoginComponent } from './login/login.component';
const data = environment;

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    NeoAppsdkLoginModule.forRoot(data)
  ],
  providers:[
    AuthGuard,
    MessageService,
    InitConfigService,
    NeoUtilService,
    {
        provide: APP_INITIALIZER,
        useFactory: (config: InitConfigService) => () => config.load(),
        deps: [InitConfigService],
        multi: true
    },
    {
        provide: HTTP_INTERCEPTORS,
        useClass: TokenInterceptor,
        multi: true
    }
],
  bootstrap: [AppComponent]
})
export class AppModule { }
