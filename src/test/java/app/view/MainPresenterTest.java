package app.view;

import app.model.Book;
import app.model.requestresponse.Request;
import app.model.requestresponse.Response;
import app.service.Service;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;

import java.io.IOException;
import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

class MainPresenterTest {

    /*TODO: Write tests to assure that the Presenter and View classes interact as expected.  If the services throw an error,
    *  the view.displayErrorMessage() function should be called inside the presenter class.  You will need to use
    *  mock objects to effectively test the presenter.
    */
    @Mock
    private I_MainView mockView;
    @Mock
    private Service mockTitleService;
    @Mock
    private Service mockAuthorService;
    @Mock
    private Service mockTopicService;

    @InjectMocks
    private MainPresenter mainPresenter;

    @BeforeEach
    void setUp(){
        I_MainView view = Mockito.mock(I_MainView.class);
//        Service service = Mockito.mock(Service.class);
        Service titleService = Mockito.mock(Service.class);
        Service authorService = Mockito.mock(Service.class);
        Service topicService = Mockito.mock(Service.class);

        Book[] books = {new Book("Title 1", "Author 1", new String[]{"Topic 1", "Topic 2"}),
                new Book("Title 2", "Author 2", new String[]{"Topic 3", "Topic 4"})};


        try {
            Mockito.when(titleService.run(Mockito.any(Request.class))).thenReturn(new Response(books));
            Mockito.when(authorService.run(Mockito.any(Request.class))).thenReturn(new Response(books));
            Mockito.when(topicService.run(Mockito.any(Request.class))).thenReturn(new Response(books));
        } catch (IOException ignored) {

        }

        mainPresenter = new MainPresenter(view, titleService, authorService, topicService);
    }

//    @Test
//    void shouldPrintErrorMessage_whenReceiveInvalidResponse() throws IOException {
//        mainPresenter.titleSearch("Exception");
//        Mockito.verify(mainPresenter.getTitleService(), Mockito.times(1)).run(Mockito.any());
//
//        Mockito.verify(mainPresenter.getView(), Mockito.times(1)).displayErrorMessage(Mockito.anyString());
//    }

    @Test
    void shouldDisplayErrorMessageForInvalidTitleSearch() throws IOException {
        // Testing invalid input
        mainPresenter.titleSearch("");

        // Verifying that the view's displayErrorMessage method was called
        Mockito.verify(mainPresenter.getView(), Mockito.times(1)).displayErrorMessage(Mockito.anyString());
    }

    @Test
    void shouldDisplayAuthorSearchResults() {
        mainPresenter.authorSearch("valid input");
        Mockito.verify(mainPresenter.getView(), Mockito.times(1)).displayAuthorSearchResults(Mockito.any());
    }

    @Test
    void shouldDisplayErrorMessageForInvalidAuthorSearch() throws IOException {
        // Testing invalid input
        mainPresenter.authorSearch("");

        // Verifying that the view's displayErrorMessage method was called
        Mockito.verify(mainPresenter.getView(), Mockito.times(1)).displayErrorMessage(Mockito.anyString());
    }

    @Test
    void shouldDisplayTopicSearchResults() {
        mainPresenter.topicSearch("valid input");
        Mockito.verify(mainPresenter.getView(), Mockito.times(1)).displayTopicSearchResults(Mockito.any());
    }

    @Test
    void shouldDisplayErrorMessageForInvalidTopicSearch() throws IOException {
        // Testing invalid input
        mainPresenter.topicSearch("");

        // Verifying that the view's displayErrorMessage method was called
        Mockito.verify(mainPresenter.getView(), Mockito.times(1)).displayErrorMessage(Mockito.anyString());
    }

    @Test
    void shouldPrintTitleSearchResults_whenSearchIsSuccessful() throws IOException {
        mainPresenter.titleSearch("valid input");
        Mockito.verify(mainPresenter.getView(), Mockito.times(1)).displayTitleSearchResults(Mockito.any());
    }


}