class ChamadoMailer < ActionMailer::Base
  def forgot_password(user)
		setup_email(user)
    @subject += ' Alteração de senha'
    if RAILS_ENV == "production"
      @body[:url]  = "http://sisgered.seducpma.com/reset_password/#{user.password_reset_code}"
    else
      @body[:url]  = "http://localhost:3000/reset_password/#{user.password_reset_code}"
    end
  end

  protected

  def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "no-reply@seducpma.com"
      @subject     = "SEDUC INFORMÁTICA -"
      @sent_on     = Time.now
      @body[:user] = user
    end
end
