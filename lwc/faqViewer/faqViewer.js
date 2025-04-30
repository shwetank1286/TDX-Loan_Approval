import { LightningElement } from 'lwc';

export default class FaqViewer extends LightningElement {
    faqs = [
        {
            id: 1,
            question: 'How long does loan approval take?',
            answer: 'Typically between 24-48 hours depending on verification.'
        },
        {
            id: 2,
            question: 'What documents do I need to upload?',
            answer: 'Valid ID proof, income documents, and address proof.'
        },
        {
            id: 3,
            question: 'Can I check the status of my loan?',
            answer: 'Yes, visit the “My Loan Requests” section.'
        },
        {
            id: 4,
            question: 'What types of loans are available?',
            answer: 'Home, Car, Personal, and Education loans.'
        }
    ];
}