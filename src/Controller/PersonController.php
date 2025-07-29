<?php

namespace App\Controller;

use App\Entity\Person;
use App\Form\PersonType;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class PersonController extends AbstractController
{
    #[Route('/', name: 'person_form')]
    public function index(Request $request, EntityManagerInterface $em): Response
    {
        $person = new Person();
        $form = $this->createForm(PersonType::class, $person);
        $form->handleRequest($request);

        if ($form->isSubmitted() && $form->isValid()) {
            $em->persist($person);
            $em->flush();

            $this->addFlash('success', 'Jméno bylo uloženo.');

            return $this->redirectToRoute('person_form');
        }

        return $this->render('person/index.html.twig', [
            'form' => $form->createView(),
        ]);
    }
}
