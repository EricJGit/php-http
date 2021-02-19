<?php

namespace App\Controller;

use Http\Client\HttpClient;
use Http\Discovery\Psr17FactoryDiscovery;
use Psr\Http\Client\ClientInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;

class IndexController extends AbstractController
{
    public function __construct(
        private HttpClient $httplugClient,
        private ClientInterface $psr18Client,
    )
    {
    }

    #[Route('/', name: 'root')]
    public function index()
    {
        $request = Psr17FactoryDiscovery::findRequestFactory()->createRequest('GET', 'https://github.com/zianwar/go-grpc-demo/blob/master/server/server.go');

        dump($this->psr18Client);
        //dump($this->httplugClient);

        dump($request);

        $this->psr18Client->sendRequest($request);
        //$this->httplugClient->sendRequest($request);

        return new Response("OK");
    }
}
